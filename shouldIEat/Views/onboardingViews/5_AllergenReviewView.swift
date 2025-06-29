import SwiftUI

struct AllergenReviewView: View {
    // ViewModel 공유
    @ObservedObject var viewModel: AllergenInputViewModel
    @State private var setupComplete = false
    
    // 각 심각도별 알레르겐 필터링
    private func allergensWithSeverity(_ level: AllergenLevel) -> [UsersAllergen] {
        return viewModel.selectedAllergens.filter { $0.severityLevel == level }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // 헤더
                VStack(alignment: .leading, spacing: 8) {
                    Text("All set? Let's double-check.")
                        .font(.title2)
                        .fontWeight(.bold)
                        
                    Text("Here's what we'll use to scan foods, flag risks, and generate allergy cards.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Severe 알레르겐
                let severeAllergens = allergensWithSeverity(.severe)
                if !severeAllergens.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Severe")
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)

                        Divider()
                            .padding(.horizontal)
                            .padding(.bottom, 8)

                        ForEach(severeAllergens) { allergen in
                            HStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 20, height: 20)
                                
                                Text(allergen.allergenItem.name)
                                    .fontWeight(.medium)
                                
                                Spacer()
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Moderate 알레르겐
                let moderateAllergens = allergensWithSeverity(.moderate)
                if !moderateAllergens.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Moderate")
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)

                        Divider()
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                            
                        ForEach(moderateAllergens) { allergen in
                            HStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 20, height: 20)
                                
                                Text(allergen.allergenItem.name)
                                    .fontWeight(.medium)
                                
                                Spacer()
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray4))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Mild 알레르겐
                let mildAllergens = allergensWithSeverity(.mild)
                if !mildAllergens.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Mild")
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        Divider()
                            .padding(.horizontal)
                            .padding(.bottom, 8)

                        ForEach(mildAllergens) { allergen in
                            HStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 20, height: 20)

                                Text(allergen.allergenItem.name)
                                    .fontWeight(.medium)
                                
                                Spacer()
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                    .frame(height: 32)
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Button("Edit") {
                    // 편집 버튼 - 이전 화면으로 돌아가기
                }
                .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(viewModel.selectedAllergens.count) Allergen Selected")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Button(action: {
                    setupComplete = true
                }) {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Circle().fill(Color.black))
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.gray.opacity(0.2)),
                alignment: .top
            )
        }
            .padding(.vertical)
            // .navigationTitle("Review")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $setupComplete) {
                SetupCompleteView(viewModel: viewModel)
            }
    }
}

// 프리뷰 제공
struct AllergenReviewView_Previews: PreviewProvider {
    static var previews: some View {
        AllergenReviewView(viewModel: AllergenInputViewModel())
    }
}
