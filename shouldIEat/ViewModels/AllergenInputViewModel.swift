import SwiftUI
import Combine

class AllergenInputViewModel: ObservableObject {
    // 발행된 속성들
    @Published var searchText = ""
    @Published var searchResults: [AllergenItem] = []
    @Published var selectedAllergens: [UsersAllergen] = []
    @Published var showNextScreen = false
    
    // 검색 취소 토큰
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // searchText 변경을 관찰하여 검색 결과를 업데이트
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.updateSearchResults(text: text)
            }
            .store(in: &cancellables)
    }
    
    // 텍스트 입력 시 검색 결과 업데이트
    private func updateSearchResults(text: String) {
        guard !text.isEmpty else {
            searchResults = []
            return
        }
        
        // 실시간 검색 결과 필터링
        searchResults = AllergenData.allergenItems.filter { item in
            item.name.lowercased().contains(text.lowercased())
        }
    }
    
    // 알레르겐 항목 선택 처리
    func selectAllergen(_ item: AllergenItem) {
        // 이미 선택된 항목인지 확인
        if !selectedAllergens.contains(where: { $0.allergenItem.id == item.id }) {
            // 중간 정도 심각도로 기본 추가
            let userAllergen = UsersAllergen(allergenItem: item, severityLevel: .moderate)
            selectedAllergens.append(userAllergen)
            searchText = ""
            searchResults = []
        }
    }
    
    // 선택된 알레르겐 제거
    func removeAllergen(_ allergen: UsersAllergen) {
        selectedAllergens.removeAll { $0.allergenItem.id == allergen.allergenItem.id }
    }
    
    // 데이터 저장 및 다음 화면으로 이동
    func saveAndContinue() {
        // 선택된 알레르겐을 UserData에 저장
        UserData.shared.usersAllergens = selectedAllergens
        
        // 다음 화면으로 이동 트리거
        showNextScreen = true
    }
    
    // 건너뛰기 처리
    func skip() {
        // 빈 목록으로 저장하고 다음으로 이동
        UserData.shared.usersAllergens = []
        showNextScreen = true
    }
}
