import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @ObservedObject var viewModel: ServiceIntroViewModel
    
    var body: some View {
        if isActive {
            if viewModel.isFirstLaunch {
                ServiceIntroView(viewModel: viewModel)
            } else {
                MainView()
            }
        } else {
            VStack {
                Image(systemName: "fork.knife.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.black)
                
                Text("Should I Eat?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
            }
            .onAppear {
                // 2초 후에 스플래시 화면에서 다음 화면으로 전환
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView(viewModel: ServiceIntroViewModel())
}
