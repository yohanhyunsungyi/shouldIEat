import SwiftUI

struct ServiceIntroView: View {
    @ObservedObject var viewModel: ServiceIntroViewModel
    @State private var showProfileSetup = false
    
    var body: some View {
        if showProfileSetup {
            ProfileSetupView()
        } else {
            VStack {
            Spacer()
            
            TabView(selection: $viewModel.currentPage) {
                OnboardingPage(
                    title: "Scan. Detect.",
                    subtitle: "Eat with confidence.",
                    description: "A phone scanning a dish and showing red/yellow/green alerts."
                )
                .tag(0) 
                
                OnboardingPage(
                    title: "Allergy questions",
                    subtitle: "in their language.",
                    description: "A translated allergy card being shown to a waiter who has O or X."
                )
                .tag(1)
                
                OnboardingPage(
                    title: "Made for",
                    subtitle: "your unique needs.",
                    description: "User profile with selected allergens and severity tags."
                )
                .tag(2)
            }
            .padding(.horizontal, 20)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 450)
            
            Spacer()
            Spacer()
            
            // 페이지 인디케이터
            HStack(spacing: 10) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(viewModel.currentPage == index ? Color.black : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            .padding()
            
            Spacer()

            // 시작하기 버튼
            Button(action: {
                if viewModel.currentPage == 2 {
                    // 마지막 페이지에서는 프로필 설정 화면으로 이동
                    showProfileSetup = true
                } else {
                    // 그 외에는 다음 페이지로
                    viewModel.nextPage()
                }
            }) {
                HStack {
                    Text("Let's Get Started")
                    Image(systemName: "arrow.right")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            Spacer()
        }
        .padding(.vertical)
        }
    }
}

struct OnboardingPage: View {
    let title: String
    let subtitle: String
    let description: String
    
    var body: some View {
        VStack(spacing: 20) {
            // 이미지 영역
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .aspectRatio(1, contentMode: .fit)
                
                VStack {
                    Text(description)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            
            // 텍스트 영역 
            VStack(spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(subtitle)
                    .font(.title3)
            }
        }
    }
}

#Preview {
    ServiceIntroView(viewModel: ServiceIntroViewModel())
}
