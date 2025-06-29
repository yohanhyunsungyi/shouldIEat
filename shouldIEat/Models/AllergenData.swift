import Foundation

/// 알레르겐 데이터를 제공하는 클래스
class AllergenData {
    /// 모든 알레르겐 항목 리스트
    static let allergenItems: [AllergenItem] = [
        // Seafood - Crustaceans
        AllergenItem(id: 1, name: "Crab", category: .seafoodCrustaceans, allergenType: .ingestion, riskLevel: .high),
        AllergenItem(id: 2, name: "Lobster", category: .seafoodCrustaceans, allergenType: .ingestion, riskLevel: .high),
        AllergenItem(id: 3, name: "Shrimp", category: .seafoodCrustaceans, allergenType: .ingestion, riskLevel: .high),
        
        // Seafood - Fish
        AllergenItem(id: 4, name: "Anchovy", category: .seafoodFish, allergenType: .ingestion, riskLevel: .medium),
        AllergenItem(id: 5, name: "Cod", category: .seafoodFish, allergenType: .ingestion, riskLevel: .high),
        AllergenItem(id: 6, name: "Mackerel", category: .seafoodFish, allergenType: .ingestion, riskLevel: .high),
        AllergenItem(id: 7, name: "Salmon", category: .seafoodFish, allergenType: .ingestion, riskLevel: .high),
        AllergenItem(id: 8, name: "Tuna", category: .seafoodFish, allergenType: .ingestion, riskLevel: .high),
        
        // Seafood - Mollusks
        AllergenItem(id: 9, name: "Abalone", category: .seafoodMollusks, allergenType: .ingestion, riskLevel: .medium),
        AllergenItem(id: 10, name: "Clam", category: .seafoodMollusks, allergenType: .ingestion, riskLevel: .medium),
        AllergenItem(id: 11, name: "Mussel", category: .seafoodMollusks, allergenType: .ingestion, riskLevel: .medium),
        AllergenItem(id: 12, name: "Oyster", category: .seafoodMollusks, allergenType: .ingestion, riskLevel: .medium),
        AllergenItem(id: 13, name: "Snail", category: .seafoodMollusks, allergenType: .ingestion, riskLevel: .medium),
        AllergenItem(id: 14, name: "Squid", category: .seafoodMollusks, allergenType: .ingestion, riskLevel: .medium),
        
        // Meat
        AllergenItem(id: 15, name: "Beef", category: .meat, allergenType: .ingestion, riskLevel: .low),
        AllergenItem(id: 16, name: "Chicken", category: .meat, allergenType: .ingestion, riskLevel: .low),
        AllergenItem(id: 17, name: "Lamb", category: .meat, allergenType: .ingestion, riskLevel: .low),
        AllergenItem(id: 18, name: "Pork", category: .meat, allergenType: .ingestion, riskLevel: .low),
        
        // Fruits
        AllergenItem(id: 19, name: "Apple", category: .fruits, allergenType: .crossReaction, riskLevel: .medium),
        AllergenItem(id: 20, name: "Banana", category: .fruits, allergenType: .crossReaction, riskLevel: .medium),
        AllergenItem(id: 21, name: "Cherry", category: .fruits, allergenType: .crossReaction, riskLevel: .medium),
        AllergenItem(id: 22, name: "Kiwi", category: .fruits, allergenType: .crossReaction, riskLevel: .medium),
        AllergenItem(id: 23, name: "Peach", category: .fruits, allergenType: .crossReaction, riskLevel: .medium),
        AllergenItem(id: 24, name: "Persimmon", category: .fruits, allergenType: .ingestion, riskLevel: .low),
        AllergenItem(id: 25, name: "Strawberry", category: .fruits, allergenType: .crossReaction, riskLevel: .medium),
        
        // Vegetables
        AllergenItem(id: 26, name: "Bracken", category: .vegetables, allergenType: .ingestion, riskLevel: .low),
        AllergenItem(id: 27, name: "Burdock", category: .vegetables, allergenType: .ingestion, riskLevel: .low),
        AllergenItem(id: 28, name: "Celery", category: .vegetables, allergenType: .ingestion, riskLevel: .medium),
        AllergenItem(id: 29, name: "Eggplant", category: .vegetables, allergenType: .ingestion, riskLevel: .low),
        AllergenItem(id: 30, name: "Lotus root", category: .vegetables, allergenType: .ingestion, riskLevel: .low),
        AllergenItem(id: 31, name: "Perilla leaf", category: .vegetables, allergenType: .ingestion, riskLevel: .medium),
        AllergenItem(id: 32, name: "Tomato", category: .vegetables, allergenType: .ingestion, riskLevel: .low),
        
        // Grains & Gluten - Cereal grains
        AllergenItem(id: 33, name: "Barley", category: .grainsGlutenCereal, allergenType: .ingestion, riskLevel: .low),
        AllergenItem(id: 34, name: "Buckwheat", category: .grainsGlutenCereal, allergenType: .ingestion, riskLevel: .medium),
        AllergenItem(id: 35, name: "Corn", category: .grainsGlutenCereal, allergenType: .ingestion, riskLevel: .low),
        AllergenItem(id: 36, name: "Oat", category: .grainsGlutenCereal, allergenType: .ingestion, riskLevel: .low),
        AllergenItem(id: 37, name: "Rice", category: .grainsGlutenCereal, allergenType: .ingestion, riskLevel: .low),
        AllergenItem(id: 38, name: "Rye", category: .grainsGlutenCereal, allergenType: .ingestion, riskLevel: .low),
        AllergenItem(id: 39, name: "Wheat", category: .grainsGlutenCereal, allergenType: .ingestion, riskLevel: .high),
        
        // Grains & Gluten - Legumes
        AllergenItem(id: 40, name: "Lupin", category: .grainsGlutenLegumes, allergenType: .ingestion, riskLevel: .medium),
        
        // Grains & Gluten - Peanuts
        AllergenItem(id: 41, name: "Peanut", category: .grainsGlutenPeanuts, allergenType: .ingestion, riskLevel: .high),
        
        // Grains & Gluten - Seeds
        AllergenItem(id: 42, name: "Sesame", category: .grainsGlutenSeeds, allergenType: .ingestion, riskLevel: .high),
        
        // Grains & Gluten - Tree nuts
        AllergenItem(id: 43, name: "Almond", category: .grainsGlutenTreeNuts, allergenType: .ingestion, riskLevel: .high),
        AllergenItem(id: 44, name: "Brazil nut", category: .grainsGlutenTreeNuts, allergenType: .ingestion, riskLevel: .high),
        AllergenItem(id: 45, name: "Cashew", category: .grainsGlutenTreeNuts, allergenType: .ingestion, riskLevel: .high),
        AllergenItem(id: 46, name: "Hazelnut", category: .grainsGlutenTreeNuts, allergenType: .ingestion, riskLevel: .high),
        AllergenItem(id: 47, name: "Macadamia", category: .grainsGlutenTreeNuts, allergenType: .ingestion, riskLevel: .high),
        AllergenItem(id: 48, name: "Pecan", category: .grainsGlutenTreeNuts, allergenType: .ingestion, riskLevel: .high),
        AllergenItem(id: 49, name: "Pine nut", category: .grainsGlutenTreeNuts, allergenType: .ingestion, riskLevel: .high),
        AllergenItem(id: 50, name: "Pistachio", category: .grainsGlutenTreeNuts, allergenType: .ingestion, riskLevel: .high),
        AllergenItem(id: 51, name: "Walnut", category: .grainsGlutenTreeNuts, allergenType: .ingestion, riskLevel: .high),
        
        // Grains & Gluten - Soy
        AllergenItem(id: 52, name: "Soybean", category: .grainsGlutenSoy, allergenType: .ingestion, riskLevel: .high),
        
        // Dairy Alternatives
        AllergenItem(id: 53, name: "Almond milk", category: .dairyAlternatives, allergenType: .ingestion, riskLevel: .low),
        AllergenItem(id: 54, name: "Coconut milk", category: .dairyAlternatives, allergenType: .ingestion, riskLevel: .low),
        AllergenItem(id: 55, name: "Oat milk", category: .dairyAlternatives, allergenType: .ingestion, riskLevel: .low),
        
        // Additives
        AllergenItem(id: 56, name: "Carmine (cochineal)", category: .additives, allergenType: .ingestion, riskLevel: .medium),
        AllergenItem(id: 57, name: "Gelatin", category: .additives, allergenType: .ingestion, riskLevel: .medium),
        AllergenItem(id: 58, name: "Sulfite", category: .additives, allergenType: .ingestion, riskLevel: .medium),
        AllergenItem(id: 59, name: "Stevia", category: .additives, allergenType: .ingestion, riskLevel: .low),
        
        // Spices/Herbs
        AllergenItem(id: 60, name: "Basil", category: .spicesHerbs, allergenType: .ingestionContact, riskLevel: .low),
        AllergenItem(id: 61, name: "Cinnamon", category: .spicesHerbs, allergenType: .ingestionContact, riskLevel: .low),
        AllergenItem(id: 62, name: "Coriander", category: .spicesHerbs, allergenType: .ingestionContact, riskLevel: .low),
        AllergenItem(id: 63, name: "Ginger", category: .spicesHerbs, allergenType: .ingestionContact, riskLevel: .low),
        AllergenItem(id: 64, name: "Mustard", category: .spicesHerbs, allergenType: .ingestion, riskLevel: .medium),
        AllergenItem(id: 65, name: "Rosemary", category: .spicesHerbs, allergenType: .ingestionContact, riskLevel: .low),
        
        // Fermented food
        AllergenItem(id: 66, name: "Kimchi", category: .fermentedFood, allergenType: .histamine, riskLevel: .low),
        
        // Dairy
        AllergenItem(id: 67, name: "Milk", category: .dairy, allergenType: .ingestion, riskLevel: .high)
    ]
    
    /// 카테고리별로 그룹화된 알레르겐 항목
    static let allergensByCategory: [AllergenCategory: [AllergenItem]] = {
        var result: [AllergenCategory: [AllergenItem]] = [:]
        
        for item in allergenItems {
            if result[item.category] == nil {
                result[item.category] = []
            }
            result[item.category]?.append(item)
        }
        
        return result
    }()
    
    /// 대분류 카테고리별로 그룹화된 알레르겐 항목
    static let allergensByMainCategory: [String: [AllergenItem]] = {
        var result: [String: [AllergenItem]] = [:]
        
        for item in allergenItems {
            let mainCategory = item.category.simpleCategory
            if result[mainCategory] == nil {
                result[mainCategory] = []
            }
            result[mainCategory]?.append(item)
        }
        
        return result
    }()
    
    /// 알레르겐 객체 생성 (각 카테고리별 알레르겐 객체)
    static let allergens: [Allergen] = {
        var result: [Allergen] = []
        var id = 1
        
        // 대분류 카테고리별로 알레르겐 객체 생성
        let mainCategories = Set(allergenItems.map { $0.category.simpleCategory })
        
        for (index, category) in mainCategories.enumerated() {
            let items = allergensByMainCategory[category] ?? []
            result.append(
                Allergen(
                    id: index + 1,
                    name: category,
                    category: items.first?.category ?? .seafoodCrustaceans,
                    items: items
                )
            )
        }
        
        return result
    }()
     
    /// 알레르겐 항목 이름으로 찾기
    static func allergenItem(byName name: String) -> AllergenItem? {
        return allergenItems.first(where: { $0.name.lowercased() == name.lowercased() })
    }
}
