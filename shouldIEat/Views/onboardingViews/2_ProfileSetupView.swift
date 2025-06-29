import SwiftUI

struct ProfileSetupView: View {
    @StateObject private var viewModel: ProfileSetupViewModel
    @State private var navigateToAllergenInput = false
    
    init(viewModel: ProfileSetupViewModel? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel ?? ProfileSetupViewModel())
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                // 헤더
                VStack(alignment: .leading, spacing: 8) {
                    Text("Let's get")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("your allergy profile setup")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(.top, 40)
                
                // 설명 텍스트
                VStack(alignment: .leading, spacing: 8) {
                    Text("Set up your allergen list and severity level.")
                        .foregroundColor(.secondary)
                    
                    Text("We'll remember the rest.")
                        .foregroundColor(.secondary)
                    
                    Text("Get personalized warnings.")
                        .foregroundColor(.secondary)
                }
                .padding(.top, 10)
                
                Spacer()
                
                // 시작 버튼
                NavigationLink(destination: AllergenInputView(), isActive: $navigateToAllergenInput) {
                    EmptyView()
                }
                
                Button(action: {
                    // 알러젠 선택 화면으로 네비게이션
                    navigateToAllergenInput = true
                }) {
                    HStack {
                        Text("Let's Begin")
                        Image(systemName: "arrow.right")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }
                .padding(.bottom)
                
                // 개인정보 정책 링크
                HStack {
                    Spacer()
                    Text("Read our")
                    Text("privacy policy.")
                        .underline()
                        .foregroundColor(.blue)
                    Spacer()
                }
                .font(.footnote)
                .padding(.bottom, 30)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    ProfileSetupView()
}
