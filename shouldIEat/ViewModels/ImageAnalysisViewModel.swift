import SwiftUI
import Vision
import CoreML
import Foundation

enum AnalysisError: Error {
    case recognitionFailed
    case networkError
    case invalidResponse
    
    var localizedDescription: String {
        switch self {
        case .recognitionFailed:
            return "인식 실패"
        case .networkError:
            return "네트워크 오류"
        case .invalidResponse:
            return "잘못된 응답"
        }
    }
}

// MARK: - ChatGPT API 구조체
struct ChatGPTRequest: Codable {
    let model: String
    let messages: [ChatGPTMessage]
    let maxTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case model
        case messages
        case maxTokens = "max_tokens"
    }
}

struct ChatGPTMessage: Codable {
    let role: String
    let content: [ChatGPTContent]
}

struct ChatGPTContent: Codable {
    let type: String
    let text: String?
    let imageUrl: ChatGPTImageUrl?
    
    enum CodingKeys: String, CodingKey {
        case type
        case text
        case imageUrl = "image_url"
    }
}

struct ChatGPTImageUrl: Codable {
    let url: String
}

struct ChatGPTResponse: Codable {
    let choices: [ChatGPTChoice]
}

struct ChatGPTChoice: Codable {
    let message: ChatGPTResponseMessage
}

struct ChatGPTResponseMessage: Codable {
    let content: String
}

class ImageAnalysisViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var imageType: ImageType = .menu
    @Published var isAnalyzing: Bool = false
    @Published var analysisResult: AnalysisResult?
    @Published var currentStep: AnalysisStep = .imageTypeSelection
    @Published var showResultSheet: Bool = false
    @Published var allergyCard: AllergyCard?
    
    @Published var currentLocation: String = "현재 위치"
    
    // OpenAI API 설정
    private let openAIAPIKey = "" // 실제 API 키로 교체 필요
    private let openAIBaseURL = "https://api.openai.com/v1/chat/completions"
    
    enum AnalysisStep {
        case imageTypeSelection
        case result
    }
    
    enum ImageType: CaseIterable {
        case menu, dish
        
        var title: String {
            switch self {
            case .menu: return "Menu Image"
            case .dish: return "Dish Image"
            }
        }
    }
    
    struct AnalysisResult {
        let foodName: String
        let detectedItems: [String]
        let allergyWarnings: [String]
        let ingredients: [String]
    }
    
    init(image: UIImage) {
        self.selectedImage = image
    }
    
    func updateImageType(_ type: ImageType) {
        imageType = type
    }
    
    func startAnalysis() {
        guard let image = selectedImage else { return }
        isAnalyzing = true
        performVisionAnalysis(image: image)
    }
    
    private func performVisionAnalysis(image: UIImage) {
        print("ChatGPT Vision API로 이미지 분석 시작")
        
        Task {
            do {
                // 이미지를 Base64로 변환
                guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                    await MainActor.run {
                        self.handleAnalysisError("이미지를 처리할 수 없습니다.")
                    }
                    return
                }
                
                let base64Image = imageData.base64EncodedString()
                
                // ChatGPT Vision API를 사용한 분석
                let result = try await analyzeFoodWithChatGPT(imageBase64: base64Image)
                
                await MainActor.run {
                    self.handleLLMResult(result)
                }
                
            } catch {
                await MainActor.run {
                    print("ChatGPT 분석 오류: \(error.localizedDescription)")
                    self.fallbackToMockResult()
                }
            }
        }
    }
    
    private func analyzeFoodWithChatGPT(imageBase64: String) async throws -> String {
        // ChatGPT Vision API 프롬프트 생성
        let prompt = """
        이 이미지를 분석해서 다음 정보를 JSON 형식으로 제공해 주세요:
        {
          "foodName": "음식 이름 (영어)",
          "detectedItems": ["인식된 음식 항목들 (영어)"],
          "allergyWarnings": ["포함될 수 있는 알레르겐들 (영어)"],
          "ingredients": ["주요 재료들 (영어)"]
        }
        
        allergen examples: Crab, Lobster, Shrimp, Anchovy, Cod, Mackerel, Salmon, Tuna, Abalone, Clam, Mussel, Oyster, Squid, Beef, Chicken, Pork, Apple, Banana, Strawberry, Tomato, Celery, Wheat, Buckwheat, Peanut, Sesame, Almond, Walnut, Soybean, Milk, Mustard, Gelatin
        """
        
        // ChatGPT API 요청 생성
        let request = ChatGPTRequest(
            model: "gpt-4o",
            messages: [
                ChatGPTMessage(
                    role: "user",
                    content: [
                        ChatGPTContent(
                            type: "text",
                            text: prompt,
                            imageUrl: nil
                        ),
                        ChatGPTContent(
                            type: "image_url",
                            text: nil,
                            imageUrl: ChatGPTImageUrl(
                                url: "data:image/jpeg;base64,\(imageBase64)"
                            )
                        )
                    ]
                )
            ],
            maxTokens: 1000
        )
        
        return try await sendChatGPTRequest(request)
    }
    
    private func sendChatGPTRequest(_ request: ChatGPTRequest) async throws -> String {
        guard let url = URL(string: openAIBaseURL) else {
            throw AnalysisError.networkError
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(openAIAPIKey)", forHTTPHeaderField: "Authorization")
        
        do {
            let requestData = try JSONEncoder().encode(request)
            urlRequest.httpBody = requestData
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("HTTP 오류: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                throw AnalysisError.networkError
            }
            
            let chatGPTResponse = try JSONDecoder().decode(ChatGPTResponse.self, from: data)
            
            guard let content = chatGPTResponse.choices.first?.message.content else {
                throw AnalysisError.invalidResponse
            }
            
            print("ChatGPT Vision API 응답: \(content)")
            return content
            
        } catch {
            if error is AnalysisError {
                throw error
            } else {
                print("ChatGPT API 오류: \(error.localizedDescription)")
                throw AnalysisError.networkError
            }
        }
    }
    
    private func handleLLMResult(_ jsonString: String) {
        do {
            // 마크다운 코드 블록 제거 전처리
            let cleanedJsonString = cleanJsonString(jsonString)
            print("Cleaned JSON: \(cleanedJsonString)")
            
            let jsonData = cleanedJsonString.data(using: .utf8)!
            let decoder = JSONDecoder()
            let response = try decoder.decode(LLMFoodAnalysisResponse.self, from: jsonData)
            
            let analysisResult = AnalysisResult(
                foodName: response.foodName,
                detectedItems: response.detectedItems,
                allergyWarnings: response.allergyWarnings,
                ingredients: response.ingredients
            )
            
            self.analysisResult = analysisResult
            self.isAnalyzing = false
            self.currentStep = .result
            
            // AllergyCard 자동 생성
            self.createAllergyCard()
            
            // ResultView sheet 표시
            self.showResultSheet = true
            
            print("LLM 분석 완료: \(response.foodName)")
            
        } catch {
            print("LLM 결과 파싱 오류: \(error.localizedDescription)")
            fallbackToMockResult()
        }
    }
    
    private func cleanJsonString(_ rawString: String) -> String {
        var cleanedString = rawString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // ```json 제거
        if cleanedString.hasPrefix("```json") {
            cleanedString = String(cleanedString.dropFirst(7))
        }
        
        // ``` 제거
        if cleanedString.hasSuffix("```") {
            cleanedString = String(cleanedString.dropLast(3))
        }
        
        return cleanedString.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private struct LLMFoodAnalysisResponse: Codable {
        let foodName: String
        let detectedItems: [String]
        let allergyWarnings: [String]
        let ingredients: [String]
    }
    
    // MARK: - AllergyCard Analysis
    
    struct AllergenButton {
        let name: String
        let isSelected: Bool
    }

    func getAllergenButtons() -> [AllergenButton] {
        guard let result = analysisResult else {
            return []
        }
        
        let userData = UserData.shared
        let userAllergenNames = userData.usersAllergens.map { $0.allergenItem.name }
        
        // 사용자의 알레르겐과 겹치는 것만 필터링
        let matchingAllergens = result.allergyWarnings.filter { allergenName in
            userAllergenNames.contains(allergenName)
        }
        
        return matchingAllergens.map { allergenName in
            return AllergenButton(name: allergenName, isSelected: true)
        }
    }
    
    func getIngredientSummary() -> String {
        guard let result = analysisResult else {
            return ""
        }
        
        // 실제 LLM에서 받아온 ingredients 데이터를 직접 사용
        return result.ingredients.joined(separator: ", ")
    }
    
    func createAllergyCard() {
        guard let result = analysisResult else { return }
        
        let userData = UserData.shared
        let userAllergenNames = userData.usersAllergens.map { $0.allergenItem.name }
        
        // 사용자의 알레르겐과 겹치는 것만 필터링
        let matchingAllergens = result.allergyWarnings.filter { allergenName in
            userAllergenNames.contains(allergenName)
        }
        
        let containAllergens = createContainAllergens(from: matchingAllergens)
        
        let card = AllergyCard(
            foodName: result.foodName,
            date: Date(),
            location: currentLocation,
            containAllergens: containAllergens
        )
        
        self.allergyCard = card
        print("AllergyCard 생성 완료: \(card.foodName)")
    }
    
    private func createContainAllergens(from warnings: [String]) -> [ContainAllergen] {
        return warnings.compactMap { warning in
            // 기본 알레르기 항목들을 생성
            let allergen = Allergen(
                id: warning.hashValue,
                name: warning,
                category: mapWarningToCategory(warning),
                items: []
            )
            
            return ContainAllergen(
                allergen: allergen,
                isContain: true
            )
        }
    }
    
    private func mapWarningToCategory(_ warning: String) -> AllergenCategory {
        let warningLower = warning.lowercased()
        
        // Seafood 카테고리들
        if warningLower.contains("crustaceans") || warningLower.contains("shrimp") || warningLower.contains("crab") {
            return .seafoodCrustaceans
        } else if warningLower.contains("fish") && !warningLower.contains("shellfish") {
            return .seafoodFish
        } else if warningLower.contains("mollusks") || warningLower.contains("shellfish") {
            return .seafoodMollusks
        } else if warningLower.contains("seafood") {
            return .seafoodCrustaceans // 일반적인 seafood는 crustaceans로 분류
        }
        
        // Grains & Gluten 카테고리들
        else if warningLower.contains("peanuts") {
            return .grainsGlutenPeanuts
        } else if warningLower.contains("tree nuts") || warningLower.contains("nuts") {
            return .grainsGlutenTreeNuts
        } else if warningLower.contains("soy") || warningLower.contains("soya") {
            return .grainsGlutenSoy
        } else if warningLower.contains("legumes") || warningLower.contains("beans") {
            return .grainsGlutenLegumes
        } else if warningLower.contains("seeds") {
            return .grainsGlutenSeeds
        } else if warningLower.contains("grains") || warningLower.contains("gluten") || warningLower.contains("cereal") {
            return .grainsGlutenCereal
        }
        
        // Dairy 카테고리들
        else if warningLower.contains("dairy alternatives") {
            return .dairyAlternatives
        } else if warningLower.contains("dairy") || warningLower.contains("milk") {
            return .dairy
        }
        
        // 기타 카테고리들
        else if warningLower.contains("meat") {
            return .meat
        } else if warningLower.contains("fruits") {
            return .fruits
        } else if warningLower.contains("vegetables") {
            return .vegetables
        } else if warningLower.contains("spices") || warningLower.contains("herbs") {
            return .spicesHerbs
        } else if warningLower.contains("fermented") {
            return .fermentedFood
        } else {
            return .additives
        }
    }
    
    private func fallbackToMockResult() {
        DispatchQueue.main.async {
            self.isAnalyzing = false
            self.currentStep = .imageTypeSelection
            print("음식 인식 실패")
            // 인식 실패 메시지 표시 및 초기 상태로 되돌아감
        }
    }

    private func handleAnalysisError(_ message: String) {
        print("Analysis Error: \(message)")
        
        let errorResult = AnalysisResult(
            foodName: "분석 실패",
            detectedItems: ["분석 실패"],
            allergyWarnings: ["이미지 분석 중 오류가 발생했습니다"],
            ingredients: [],
        )
        
        self.analysisResult = errorResult
        self.isAnalyzing = false
        self.showResultSheet = true
    }
    
    // MARK: - AllergyCard 저장
    
    func updateAllergyCardWithSelectedAllergens(_ selectedAllergens: Set<String>) {
        guard var card = self.allergyCard else { return }
        
        // 체크된 알레르겐만 남기도록 필터링
        let filteredContainAllergens = card.containAllergens.filter { containAllergen in
            selectedAllergens.contains(containAllergen.allergen.name)
        }
        
        // 업데이트된 카드 생성
        let updatedCard = AllergyCard(
            foodName: card.foodName,
            date: card.date,
            location: card.location,
            containAllergens: filteredContainAllergens
        )
        
        self.allergyCard = updatedCard
        print("체크된 알레르겐만 남김: \(filteredContainAllergens.count)개")
    }
    
    func saveAllergyCard() {
        guard let allergyCard = self.allergyCard else {
            print("저장할 AllergyCard가 없습니다")
            return
        }
        
        var savedCards = UserData.shared.allergyCards
        savedCards.append(allergyCard)
        UserData.shared.allergyCards  = savedCards
        
        print("AllergyCard 저장 완료: \(allergyCard.foodName)")
        print("총 저장된 카드 수: \(savedCards.count)")
    }

}
