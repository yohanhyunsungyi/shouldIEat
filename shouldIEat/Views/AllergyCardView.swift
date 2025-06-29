import SwiftUI

struct AllergyCardView: View {
    @State private var allergyCards: [AllergyCard] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 헤더 섹션
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Allergy Card")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Quick access to your allergy cards for restaurant staff")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 20)
            
            if allergyCards.isEmpty {
                // 카드가 없을 때
                VStack(spacing: 16) {
                    Spacer()
                    
                    Image(systemName: "heart.text.square")
                        .font(.system(size: 60))
                        .foregroundColor(.gray.opacity(0.5))
                    
                    Text("Your allergy cards will show up here, handy when dining abroad!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Go to set-up allergy profile")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                }
            } else {
                // 카드 리스트
                ScrollView {
                    LazyVStack(spacing: 5) {
                        ForEach(allergyCards, id: \.foodName) { card in
                            AllergyCardRowView(card: card)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            loadAllergyCards()
        }
    }
    
    private func loadAllergyCards() {
        allergyCards = UserData.shared.allergyCards
    }
}

struct AllergyCardRowView: View {
    let card: AllergyCard
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            CardHeaderView(card: card)
            Divider()
            AllergenListView(allergens: card.containAllergens)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
}

struct CardHeaderView: View {
    let card: AllergyCard
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(card.foodName)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(formatDate(card.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if card.location != nil {
                VStack(alignment: .trailing, spacing: 2) {
                    Image(systemName: "location.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Mexico")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct AllergenListView: View {
    let allergens: [ContainAllergen]
    
    var body: some View {
        if !allergens.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("Contains Allergens:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(allergens, id: \.allergen.name) { allergen in
                        AllergenBadgeView(allergen: allergen)
                    }
                }
            }
        } else {
            Text("No allergens detected")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .italic()
        }
    }
}

struct AllergenBadgeView: View {
    let allergen: ContainAllergen
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.gray)
                .frame(width: 8, height: 8)
            
            Text(allergen.allergen.name)
                .font(.caption)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

#Preview {
    AllergyCardView()
}
