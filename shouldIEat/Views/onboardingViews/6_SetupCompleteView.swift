import SwiftUI

struct SetupCompleteView: View {
    @ObservedObject var viewModel: AllergenInputViewModel
    @State private var navigateToMain = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // 프로필 아이콘 (회색 카드 형태)
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray4))
                    .frame(width: 160, height: 120)
                    .overlay(
                        VStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemGray3))
                                .frame(width: 80, height: 12)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemGray3))
                                .frame(width: 60, height: 8)
                        }
                    )
            }
            
            // 타이틀 텍스트
            VStack(spacing: 8) {
                Text("All set!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Let's get started")
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            // 메인 버튼
            Button(action: {
                // UserData에 알레르겐 정보 저장
                UserData.shared.usersAllergens = viewModel.selectedAllergens
                UserData.shared.isProfileSetup = true
                
                // 메인 화면으로 이동
                navigateToMain = true
            }) {
                Text("See my Allergy Profile")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.black)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .background(
            NavigationLink(
                destination: MainView(),
                isActive: $navigateToMain
            ) {
                EmptyView()
            }
            .hidden()
        )
    }
}

// 프리뷰 제공
struct SetupCompleteView_Previews: PreviewProvider {
    static var previews: some View {
        SetupCompleteView(viewModel: AllergenInputViewModel())
    }
}
