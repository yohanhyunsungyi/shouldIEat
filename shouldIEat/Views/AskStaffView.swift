import SwiftUI
import Translation

struct AskStaffView: View {
    @ObservedObject var viewModel: ImageAnalysisViewModel
    let onBack: () -> Void
    let onGoHome: () -> Void
    
    @State private var selectedAllergens: Set<String> = []
    @State private var selectedLanguage = "Select"
    @State private var showLanguageSelector = false
    @State private var isTranslated = false
    @State private var showCompletedView = false
    @State private var translatedText1 = ""
    @State private var translatedText2 = ""
    @State private var translatedButton = ""
    @State private var translatedAllergens: [String: String] = [:]
    @State private var configuration: TranslationSession.Configuration?
    
    let languages = [
        "English",
        "한국어",
        "Español",
        "Français",
        "Deutsch",
        "Italiano",
        "日本語",
        "中文",
        "Português",
        "Русский"
    ]
    
    var body: some View {
        VStack(spacing: 0) { 
            // 메인 컨텐츠
            VStack(spacing: 0) {
                // 번역 섹션 (iOS 17.4+에서만 표시)
                if #available(iOS 17.4, *) {
                    Button(action: {
                        if isTranslated {
                            // 원본 텍스트로 돌아가기
                            isTranslated = false
                            translatedText1 = ""
                            translatedText2 = ""
                            translatedButton = ""
                            translatedAllergens.removeAll()
                        } else {
                            // 언어 선택 다이얼로그 표시
                            showLanguageSelector = true
                        }
                    }) {
                        HStack {
                            Image(systemName: "globe")
                                .foregroundColor(.black)
                                .font(.system(size: 16))
                            Text(isTranslated ? "See Original" : "Tap to translate in")
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                            Spacer()
                            if !isTranslated {
                                Text(selectedLanguage)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                
                // 메시지 텍스트들
                VStack(alignment: .leading, spacing: 16) {
                    Text(isTranslated && !translatedText1.isEmpty ? translatedText1 : "Hi, I have some food allergies. Could you help me check a few ingredients?")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    
                    Text(isTranslated && !translatedText2.isEmpty ? translatedText2 : "Does this dish contain any of the following?")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 24)
                
                // 알레르겐 체크박스 리스트
                VStack(spacing: 0) {
                    let containAllergens = viewModel.allergyCard?.containAllergens ?? []
                    ForEach(Array(containAllergens.enumerated()), id: \.offset) { index, containAllergen in
                        AllergenCheckboxRow(
                            allergen: isTranslated && translatedAllergens[containAllergen.allergen.name] != nil ? translatedAllergens[containAllergen.allergen.name]! : containAllergen.allergen.name,
                            isSelected: selectedAllergens.contains(containAllergen.allergen.name)
                        ) {
                            toggleAllergenSelection(containAllergen.allergen.name)
                        }
                        
                        // 구분선 (마지막 항목 제외)
                        if index < containAllergens.count - 1 {
                            Divider()
                                .padding(.horizontal, 20)
                        }
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                
                // Confirmed 버튼
                Button(action: {
                    // 체크된 알레르겐만 남기고 AllergyCard 저장 후 완료 화면으로 이동
                    viewModel.updateAllergyCardWithSelectedAllergens(selectedAllergens)
                    viewModel.saveAllergyCard()
                    showCompletedView = true
                }) {
                    Text(isTranslated && !translatedButton.isEmpty ? translatedButton : "Confirmed")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black)
                        )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .background(Color.white)
            .translationTask(configuration) { session in
                guard let config = configuration else { return }
                
                print("Translation task started")
                
                do {
                    
                    // 번역할 텍스트들 준비
                    var requests: [TranslationSession.Request] = []
                    
                    // 첫 번째 메시지
                    requests.append(TranslationSession.Request(
                        sourceText: "Hi, I have some food allergies. Could you help me check a few ingredients?",
                        clientIdentifier: "message1"
                    ))
                    
                    // 두 번째 메시지
                    requests.append(TranslationSession.Request(
                        sourceText: "Does this dish contain any of the following?",
                        clientIdentifier: "message2"
                    ))
                    
                    // 버튼 텍스트
                    requests.append(TranslationSession.Request(
                        sourceText: "Confirmed",
                        clientIdentifier: "button"
                    ))
                    
                    // 알레르겐 이름들
                    let containAllergens = viewModel.allergyCard?.containAllergens ?? []
                    for containAllergen in containAllergens {
                        requests.append(TranslationSession.Request(
                            sourceText: containAllergen.allergen.name,
                            clientIdentifier: "allergen_\(containAllergen.allergen.name)"
                        ))
                    }
                    
                    // 번역 실행
                    let responses = try await session.translations(from: requests)
                    
                    await MainActor.run {
                        for response in responses {
                            switch response.clientIdentifier {
                            case "message1":
                                self.translatedText1 = response.targetText
                            case "message2":
                                self.translatedText2 = response.targetText
                            case "button":
                                self.translatedButton = response.targetText
                            default:
                                if let clientId = response.clientIdentifier, clientId.hasPrefix("allergen_") {
                                    let originalText = String(clientId.dropFirst("allergen_".count))
                                    self.translatedAllergens[originalText] = response.targetText
                                }
                            }
                        }
                        // 번역 완료 후 UI 업데이트
                        self.isTranslated = true
                    }
                } catch {
                    print("Translation failed: \(error)")
                    // 번역 실패 시에도 번역 상태는 업데이트하지 않음
                }
            }
            
            // Sheet for AllergyCheckCompletedView
            .sheet(isPresented: $showCompletedView) {
                AllergyCheckCompletedView {
                    onGoHome()
                }
                .presentationDetents([.large])
            }
        }
        .navigationBarHidden(true)
        .confirmationDialog("Select Language", isPresented: $showLanguageSelector, titleVisibility: .visible) {
            ForEach(languages, id: \.self) { language in
                Button(language) {
                    selectedLanguage = language
                    if let languageCode = getLanguageCode(for: language) {
                        performTranslation(targetLanguage: languageCode)
                    }
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Choose a language for translation")
        }
    }
    
    private func toggleAllergenSelection(_ allergen: String) {
        if selectedAllergens.contains(allergen) {
            selectedAllergens.remove(allergen)
        } else {
            selectedAllergens.insert(allergen)
        }
    }
    
    private func performTranslation(targetLanguage: String) {
        print("Starting translation to: \(targetLanguage)")
        
        // Configuration 설정
        let newConfig = TranslationSession.Configuration(
            source: .init(identifier: "en"),
            target: .init(identifier: targetLanguage)
        )
        
        // 기존 configuration 무효화
        configuration?.invalidate()
        
        // 새 configuration 설정
        configuration = newConfig
        
        print("Translation configuration set")
    }
    
    private func getLanguageCode(for language: String) -> String? {
        switch language {
        case "English": return "en"
        case "한국어": return "ko"
        case "Español": return "es"
        case "Français": return "fr"
        case "Deutsch": return "de"
        case "Italiano": return "it"
        case "日本語": return "ja"
        case "中文": return "zh"
        case "Português": return "pt"
        case "Русский": return "ru"
        default: return nil
        }
    }
}

struct AllergenCheckboxRow: View {
    let allergen: String
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // 왼쪽 회색 원
            Circle()
                .fill(Color(UIColor.systemGray4))
                .frame(width: 20, height: 20)
            
            // 알레르겐 텍스트
            Text(formatAllergenText(allergen))
                .font(.system(size: 18))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            // 오른쪽 체크박스
            Button(action: onToggle) {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.gray, lineWidth: 1.5)
                    .frame(width: 24, height: 24)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(isSelected ? Color.clear : Color.clear)
                    )
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                            .opacity(isSelected ? 1 : 0)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .contentShape(Rectangle())
        .onTapGesture {
            onToggle()
        }
    }
    
    private func formatAllergenText(_ allergen: String) -> String {
        // 알레르겐 텍스트를 더 읽기 쉽게 포맷
        let formatted = allergen.replacingOccurrences(of: "Seafood - ", with: "")
        return formatted
    }
}
