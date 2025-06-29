import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: ImageAnalysisViewModel
    @State private var showIngredientSummary = true
    @State private var showAskStaffView = false
    let onGoHome: () -> Void
    
    var body: some View {
        if showAskStaffView {
            AskStaffView(viewModel: viewModel, onBack: {
                showAskStaffView = false
            }, onGoHome: onGoHome)
        } else {
            mainResultView()
        }
    }
    
    @ViewBuilder
    private func mainResultView() -> some View {
        ScrollView {
            VStack(spacing: 0) {
                // 음식 이름
                if let result = viewModel.analysisResult {
                    Text(result.foodName)
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                    
                    // Might have contained 섹션
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Might have contained")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // 알레르겐 버턴들
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            let allergenButtons = viewModel.getAllergenButtons()
                            ForEach(allergenButtons, id: \.name) { allergen in
                                Button(action: {}) {
                                    HStack {
                                        Circle()
                                            .fill(allergen.isSelected ? Color.white : Color.clear)
                                            .frame(width: 20, height: 20)
                                            .overlay(
                                                Circle()
                                                    .stroke(allergen.isSelected ? Color.clear : Color.gray, lineWidth: 1)
                                            )
                                        
                                        Text(allergen.name)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(allergen.isSelected ? .white : .primary)
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(allergen.isSelected ? Color.black : Color.gray.opacity(0.2))
                                    )
                                }
                                .disabled(true)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                    
                    // Ingredient Summary 섹션
                    VStack(spacing: 0) {
                        Button(action: {
                            withAnimation {
                                showIngredientSummary.toggle()
                            }
                        }) {
                            HStack {
                                Text("Ingredient Summary")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Image(systemName: showIngredientSummary ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14, weight: .medium))
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                        }
                        
                        if showIngredientSummary {
                            VStack(alignment: .leading, spacing: 0) {
                                Divider()
                                    .padding(.horizontal, 20)
                                
                                Text(viewModel.getIngredientSummary())
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                            }
                        }
                    }
                    .background(Color.gray.opacity(0.05))
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .padding(.top, 10)   
        .overlay(
            // Ask the Staff 버튼
            VStack {
                Spacer()
                Button(action: {
                    // AskStaffView를 표시
                    showAskStaffView = true
                }) {
                    Text("Ask the Staff")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background( 
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black)
                        )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 34)
            }
        )
    }
    
    // MARK: - Helper Functions
    // 분석 로직은 ImageAnalysisViewModel로 이동됨
}

#Preview {
    let mockViewModel = ImageAnalysisViewModel(image: UIImage())
    ResultView(viewModel: mockViewModel) {
        print("Go home")
    }
}
