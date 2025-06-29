import SwiftUI

struct ImageAnalysisView: View {
    @StateObject private var viewModel: ImageAnalysisViewModel
    @Environment(\.presentationMode) private var presentationMode
    @State private var isAnalyzing = false
    
    init(selectedImage: UIImage) {
        _viewModel = StateObject(wrappedValue: ImageAnalysisViewModel(image: selectedImage))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Navigation Bar
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Text("Should I Eat?")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                // Invisible placeholder for balance
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .opacity(0)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            // Image Display with blur background and overlay
            ZStack {
                if let image = viewModel.selectedImage {
                    // Blur background - full width
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: 400)
                        .clipped()
                        .blur(radius: 20)
                        .opacity(0.7)
                    
                    // image overlay
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 400)
                        .cornerRadius(15)
                        .padding(.vertical, 20)
                }
            }
            .frame(height: 400)
            .padding(.bottom, 32)
            
            // Content Container - Only shows imageTypeSelection and analyzing
            contentForCurrentStep()
                .animation(.easeInOut(duration: 0.3), value: viewModel.currentStep)
        }
        .navigationBarHidden(true)
        .background(Color(.systemBackground))
        .sheet(isPresented: $viewModel.showResultSheet) {
            ResultView(viewModel: viewModel) {
                // MainView로 돌아가기
                presentationMode.wrappedValue.dismiss()
            }
                .presentationDetents([.fraction(0.67)]) 
                .presentationDragIndicator(.visible)
        }
        .onChange(of: viewModel.showResultSheet) { showResult in
            if showResult {
                isAnalyzing = false
            }
        }
    }
    
    @ViewBuilder
    private func contentForCurrentStep() -> some View {
        imageTypeSelectionView()
    }
    
    private func imageTypeSelectionView() -> some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 24) {
                Text("What kind of image is this?")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                // Image Type Selection - Segmented Control Style
                HStack(spacing: 0) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.updateImageType(.menu)
                        }
                    }) {
                        Text("Menu Image")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(viewModel.imageType == .menu ? .black : .gray)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.updateImageType(.dish)
                        }
                    }) {
                        Text("Dish Image")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(viewModel.imageType == .dish ? .black : .gray)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                }
                .background(
                    // Background container
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.gray.opacity(0.15))
                        .overlay(
                            // Sliding selection indicator
                            GeometryReader { geometry in
                                RoundedRectangle(cornerRadius: 23)
                                    .fill(Color.white)
                                    .frame(width: geometry.size.width / 2)
                                    .offset(x: viewModel.imageType == .menu ? 0 : geometry.size.width / 2)
                                    .animation(.easeInOut(duration: 0.2), value: viewModel.imageType)
                            }
                            .padding(2)
                        )
                )
                .frame(width: 280)
                
                Text("Please select the type of image so that we can\ndeliver the best results.")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            
            Spacer()
            
            // Action Buttons
            HStack(spacing: 12) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Re-Select")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
                
                Button(action: {
                    isAnalyzing = true
                    viewModel.startAnalysis()
                }) {
                    HStack {
                        if isAnalyzing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                            Text("Analyzing...")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                        } else {
                            Text("Start Analyze")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(isAnalyzing ? Color.gray : Color.black)
                    )
                }
                .disabled(isAnalyzing)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 34)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ImageAnalysisView(selectedImage: UIImage(systemName: "photo") ?? UIImage())
}
