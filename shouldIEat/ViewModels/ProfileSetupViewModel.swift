import Foundation
import SwiftUI

class ProfileSetupViewModel: ObservableObject {
    @Published var selectedAllergens: [String] = []
    
    func saveProfile() {
        // 여기서 사용자 프로필을 저장하는 로직을 구현
        // 실제 앱에서는 UserDefaults나 Core Data 등을 사용할 수 있음
        print("프로필 저장: \(selectedAllergens)")
    }
}
