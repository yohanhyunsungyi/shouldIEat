import Foundation

struct AllergyCard: Codable, Identifiable {
    var id = UUID()
    let foodName: String
    let date: Date
    let location: String
    let containAllergens: [ContainAllergen]
}

struct ContainAllergen: Codable, Identifiable {
    var id = UUID()
    let allergen: Allergen
    let isContain: Bool
}
