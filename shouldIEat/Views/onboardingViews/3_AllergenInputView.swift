import SwiftUI

struct AllergenInputView: View {
    // ViewModel 사용
    @StateObject private var viewModel = AllergenInputViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
                // 헤더 텍스트
                VStack(alignment: .leading, spacing: 8) {
                    Text("What should we watch out for?")
                        .font(.title)
                        .fontWeight(.bold)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("Tell the ingredients you need to avoid. We'll tailor every scan and alert based on your choices.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal)
                
                ZStack(alignment: .top) {
                    VStack(spacing: 8) {
                        // 검색 필드
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            TextField("Red meat, shell fish, ...", text: $viewModel.searchText)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        
                        // 선택된 알레르겐 칩 - LazyVGrid 사용해서 자동 줄바꿈 구현 
                        let columns = [
                            GridItem(.adaptive(minimum: 80, maximum: .infinity), spacing: 6)
                        ]
                        
                        LazyVGrid(columns: columns, alignment: .leading, spacing: 6) {
                            ForEach(viewModel.selectedAllergens) { allergen in
                                HStack(spacing: 4) {
                                    Text(allergen.allergenItem.name)
                                        .font(.subheadline)
                                    
                                    Button(action: {
                                        viewModel.removeAllergen(allergen)
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.secondary)
                                            .font(.caption)
                                    }
                                }
                                .padding(.horizontal, 5)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(.systemGray5))
                                )
                            }
                        }
                        .padding(.bottom, 4)
                    }
                    .padding(.horizontal)
                    .zIndex(1) // 필드와 칩은 항상 보여야 함
                    
                    // 검색 결과 목록을 오버레이로 표시
                    if !viewModel.searchResults.isEmpty {
                        VStack(spacing: 0) {
                            // 검색 필드와 칩 영역을 넘기도록 여백 크게 조정
                            Spacer().frame(height: 50)
                            
                            ScrollView {
                                LazyVStack(alignment: .leading, spacing: 0) {
                                    ForEach(viewModel.searchResults) { item in
                                        Button(action: {
                                            viewModel.selectAllergen(item)
                                        }) {
                                            HStack {
                                                Text(item.name)
                                                Spacer()
                                                Text(item.category.simpleCategory)
                                                    .foregroundColor(.secondary)
                                                    .font(.caption)
                                            }
                                            .padding(.vertical, 8)
                                            .padding(.horizontal)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .contentShape(Rectangle())
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        .foregroundColor(.primary)
                                        .background(Color(.systemBackground))
                                        Divider()
                                    }                           
                                }
                            }
                            .frame(height: min(CGFloat(viewModel.searchResults.count) * 44, 100))
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.clear))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal)
                        .zIndex(2) // 검색 결과가 제일 위에 표시되어야 함
                    }
                }
                
                Spacer()
                
                // 하단 네비게이션 버튼
                HStack {
                    Button("Skip") {
                        viewModel.skip()
                    }
                    .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if !viewModel.selectedAllergens.isEmpty {
                        Text("\(viewModel.selectedAllergens.count) Allergens Detected")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // 다음 버튼
                    Button(action: viewModel.saveAndContinue) {
                        Image(systemName: "arrow.right")
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Circle().fill(Color.black))
                    }
                }
                .padding()
        }
        .padding(.vertical)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $viewModel.showNextScreen) {
            AllergenSeverityView(viewModel: viewModel)
        }
    }
}



// 프리뷰 제공
struct AllergenInputView_Previews: PreviewProvider {
    static var previews: some View {
        AllergenInputView()
    }
}
