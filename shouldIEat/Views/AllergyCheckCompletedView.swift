import SwiftUI

struct AllergyCheckCompletedView: View {
    @Environment(\.presentationMode) var presentationMode
    let onGoHome: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Spacer()
                
                // 완료 아이콘
                VStack(spacing: 24) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 200, height: 160)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 120, height: 80)
                                .offset(y: 20)
                        )
                    
                    Text("Allergy Check Completed")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                // Going back home 버튼
                Button(action: {
                    onGoHome()
                }) {
                    Text("Going back home")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black)
                        )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .background(Color.white)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    AllergyCheckCompletedView {
        print("Going home")
    }
}
