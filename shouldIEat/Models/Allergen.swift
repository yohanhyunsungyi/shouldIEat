import Foundation

struct AllergenItem: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let category: AllergenCategory
    let allergenType: AllergenType
    let riskLevel: RiskLevel
    
    static func == (lhs: AllergenItem, rhs: AllergenItem) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Allergen: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let category: AllergenCategory
    let items: [AllergenItem]
    
    static func == (lhs: Allergen, rhs: Allergen) -> Bool {
        return lhs.id == rhs.id
    }
}

enum AllergenType: String, Codable, CaseIterable {
    case ingestion = "Ingestion"
    case crossReaction = "Cross-reaction"
    case histamine = "Histamine"
    case ingestionContact = "Ingestion/Contact"
}

enum RiskLevel: String, Codable, CaseIterable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
}

// 대분류와 소분류를 포함하는 카테고리 구조
enum AllergenCategory: String, Codable, CaseIterable {
    case seafoodCrustaceans = "Seafood - Crustaceans"
    case seafoodFish = "Seafood - Fish"
    case seafoodMollusks = "Seafood - Mollusks"
    case meat = "Meat"
    case fruits = "Fruits"
    case vegetables = "Vegetables"
    case grainsGlutenCereal = "Grains & Gluten - Cereal grains"
    case grainsGlutenLegumes = "Grains & Gluten - Legumes"
    case grainsGlutenPeanuts = "Grains & Gluten - Peanuts"
    case grainsGlutenSeeds = "Grains & Gluten - Seeds"
    case grainsGlutenTreeNuts = "Grains & Gluten - Tree nuts"
    case grainsGlutenSoy = "Grains & Gluten - Soy"
    case dairyAlternatives = "Dairy Alternatives"
    case additives = "Additives"
    case spicesHerbs = "Spices/Herbs"
    case fermentedFood = "Fermented food"
    case dairy = "Dairy"
    
    var simpleCategory: String {
        switch self {
        case .seafoodCrustaceans, .seafoodFish, .seafoodMollusks:
            return "Seafood"
        case .meat:
            return "Meat"
        case .fruits:
            return "Fruits"
        case .vegetables:
            return "Vegetables"
        case .grainsGlutenCereal, .grainsGlutenLegumes, .grainsGlutenPeanuts, .grainsGlutenSeeds, .grainsGlutenTreeNuts, .grainsGlutenSoy:
            return "Grains & Gluten"
        case .dairyAlternatives:
            return "Dairy Alternatives"
        case .additives:
            return "Additives"
        case .spicesHerbs:
            return "Spices/Herbs"
        case .fermentedFood:
            return "Fermented food"
        case .dairy:
            return "Dairy"
        }
    }
    
    var subCategory: String {
        switch self {
        case .seafoodCrustaceans:
            return "Crustaceans"
        case .seafoodFish:
            return "Fish"
        case .seafoodMollusks:
            return "Mollusks"
        case .meat:
            return "Meat"
        case .fruits:
            return "Fruits"
        case .vegetables:
            return "Vegetables"
        case .grainsGlutenCereal:
            return "Cereal grains"
        case .grainsGlutenLegumes:
            return "Legumes"
        case .grainsGlutenPeanuts:
            return "Peanuts"
        case .grainsGlutenSeeds:
            return "Seeds"
        case .grainsGlutenTreeNuts:
            return "Tree nuts"
        case .grainsGlutenSoy:
            return "Soy"
        case .dairyAlternatives:
            return "Alternative Milk"
        case .additives:
            return "Additives"
        case .spicesHerbs:
            return "Spices"
        case .fermentedFood:
            return "Fermented food"
        case .dairy:
            return "Dairy"
        }
    }
}
