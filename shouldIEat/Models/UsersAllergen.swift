import Foundation
import SwiftUI

struct UsersAllergen: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    let allergenItem: AllergenItem
    let severityLevel: AllergenLevel
    
    static func == (lhs: UsersAllergen, rhs: UsersAllergen) -> Bool {
        return lhs.allergenItem == rhs.allergenItem
    }
}

enum AllergenLevel: String, Codable, CaseIterable {
    case severe = "Severe"
    case moderate = "Moderate"
    case mild = "Mild"
    
    var color: Color {
        switch self {
        case .severe:
            return .red
        case .moderate:
            return .orange
        case .mild:
            return .yellow
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .severe:
            return .red.opacity(0.1)
        case .moderate:
            return .orange.opacity(0.1)
        case .mild:
            return .yellow.opacity(0.1)
        }
    }
    
    var textColor: Color {
        switch self {
        case .severe:
            return .black
        case .moderate:
            return .black
        case .mild:
            return .black
        }
    }
}
