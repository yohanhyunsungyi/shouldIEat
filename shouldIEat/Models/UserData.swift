import Foundation

// UserData 모델 - 사용자의 모든 데이터 저장

class UserData {
    private enum Keys {
        static let isFirstLaunch = "isFirstLaunch"
        static let isProfileSetup = "isProfileSetup"
        static let usersAllergens = "usersAllergens"
        static let allergyCards = "allergyCards"
    }
    
    static let shared = UserData()
    
    private let userDefaults = UserDefaults.standard
    
    private init() {
        
        // TODO: Delete on Production - Debug only
        resetFirstLaunchFlag()
    }
    
    var isFirstLaunch: Bool {
        get {
            // 값이 없으면 true를 반환 (첫 실행으로 간주)
            return userDefaults.object(forKey: Keys.isFirstLaunch) as? Bool ?? true
        }
        set {
            userDefaults.set(newValue, forKey: Keys.isFirstLaunch)
        }
    }
    
    func resetFirstLaunchFlag() {
        isFirstLaunch = true
        isProfileSetup = nil
        usersAllergens = []
    }
    
    var isProfileSetup: Bool? {
        get {
            return userDefaults.object(forKey: Keys.isProfileSetup) as? Bool
        }
        set { 
            userDefaults.set(newValue, forKey: Keys.isProfileSetup)
        }
    }
    
    var usersAllergens: [UsersAllergen] {
        get {
            if let data = userDefaults.data(forKey: Keys.usersAllergens),
               let allergens = try? JSONDecoder().decode([UsersAllergen].self, from: data) {
                return allergens
            }
            return []
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                userDefaults.set(data, forKey: Keys.usersAllergens)
            }
        }
    }
    
    var allergyCards: [AllergyCard] {
        get {
            if let data = userDefaults.data(forKey: Keys.allergyCards),
               let cards = try? JSONDecoder().decode([AllergyCard].self, from: data) {
                return cards
            }
            return []
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                userDefaults.set(data, forKey: Keys.allergyCards)
            }
        }
    }
}
