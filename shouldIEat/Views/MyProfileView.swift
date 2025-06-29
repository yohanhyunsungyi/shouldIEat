import SwiftUI

struct MyProfileView: View {
    @State private var allergenSeverity: [String: AllergenLevel] = Dictionary(uniqueKeysWithValues: UserData.shared.usersAllergens.map { ($0.allergenItem.name, $0.severityLevel) })
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                // Header
                HStack {
                    Text("Your Allergy Profile")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                
                Text("Manage your allergens and any services to help you stay safe.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.bottom)
                
                // Allergen List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        // Severe Section
                        SeveritySection(title: "Severe", allergens: getAllergens(for: .severe))
                        
                        // Moderate Section
                        SeveritySection(title: "Moderate", allergens: getAllergens(for: .moderate))
                        
                        // Mild Section
                        SeveritySection(title: "Mild", allergens: getAllergens(for: .mild))
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
        }
    }
    
    private func getAllergens(for severity: AllergenLevel) -> [String] {
        return allergenSeverity.compactMap { key, value in
            value == severity ? key : nil
        }
    }
}

struct SeveritySection: View {
    let title: String
    let allergens: [String]
    
    var body: some View {
        if !allergens.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                ForEach(allergens, id: \.self) { allergen in
                    AllergenRow(allergen: allergen, severity: getSeverity(for: title))
                }
            }
        }
    }
    
    private func getSeverity(for title: String) -> AllergenLevel {
        switch title {
        case "Severe": return .severe
        case "Moderate": return .moderate
        case "Mild": return .mild
        default: return .mild
        }
    }
}

struct AllergenRow: View {
    let allergen: String
    let severity: AllergenLevel
    
    var body: some View {
        HStack {
            Circle()
                .fill(severity.color)
                .frame(width: 12, height: 12)
            
            Text(allergen)
                .font(.body)
                .foregroundColor(severity.textColor)
            
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(severity.backgroundColor)
        )
    }
}

enum AllergenSeverity {
    case severe, moderate, mild
    
    var color: Color {
        switch self {
        case .severe: return .white
        case .moderate: return .white
        case .mild: return .gray
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .severe: return .black
        case .moderate: return .gray
        case .mild: return Color.gray.opacity(0.2)
        }
    }
    
    var textColor: Color {
        switch self {
        case .severe: return .white
        case .moderate: return .white
        case .mild: return .primary
        }
    }
}

#Preview {
    MyProfileView()
}
