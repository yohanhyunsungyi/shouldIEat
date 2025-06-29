import Foundation
import SwiftUI

class ServiceIntroViewModel: ObservableObject {
    @Published var isFirstLaunch: Bool
    @Published var currentPage = 0
    
    init() {
        self.isFirstLaunch = UserData.shared.isFirstLaunch
    }
    
    func completeOnboarding() {
        UserData.shared.isFirstLaunch = false
        isFirstLaunch = false
    }
    
    func nextPage() {
        if currentPage < 2 {
            currentPage += 1
        } else {
            completeOnboarding()
        }
    }
}
