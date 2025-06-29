import SwiftUI
import UIKit
import AVFoundation

struct MainView: View {
    @State private var selectedTab = 1
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var showingImageAnalysis = false
    
    var body: some View {
        NavigationView {
            ZStack {
                TabView(selection: $selectedTab) {
                    AllergyCardView()
                        .tabItem {
                            Image(systemName: "creditcard")
                            Text("Allergy Card")
                        }
                        .tag(0)
                    
                    MyProfileView()
                        .tabItem {
                            Image(systemName: "person.circle")
                            Text("My Profile")
                        }
                        .tag(1)
                }
                .padding(.top, 20)
                .accentColor(.primary)
                .navigationBarHidden(true)
                
                // Floating Camera Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingImagePicker = true
                        }) {
                            Image(systemName: "camera.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(Color.black)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        Spacer()
                    }
                    .padding(.bottom, 34) // Tab bar height adjustment
                }
                
                // Hidden NavigationLink
                NavigationLink(
                    destination: selectedImage.map { ImageAnalysisView(selectedImage: $0) },
                    isActive: $showingImageAnalysis
                ) {
                    EmptyView()
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .onChange(of: selectedImage) { image in
                if image != nil {
                    showingImageAnalysis = true
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, CameraViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func didCaptureImage(_ image: UIImage) {
            parent.selectedImage = image
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func didSelectImageFromGallery(_ image: UIImage) {
            parent.selectedImage = image
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func didCancel() {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

protocol CameraViewControllerDelegate: AnyObject {
    func didCaptureImage(_ image: UIImage)
    func didSelectImageFromGallery(_ image: UIImage)
    func didCancel()
}

class CameraViewController: UIViewController {
    weak var delegate: CameraViewControllerDelegate?
    
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var photoOutput: AVCapturePhotoOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraPermission()
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
            setupUI()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.setupCamera()
                        self.setupUI()
                    } else {
                        self.delegate?.didCancel()
                    }
                }
            }
        default:
            delegate?.didCancel()
        }
    }
    
    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let backCamera = AVCaptureDevice.default(for: .video) else {
            print("Unable to access back camera!")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            photoOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddInput(input) && captureSession.canAddOutput(photoOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(photoOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.frame = view.layer.bounds
                view.layer.addSublayer(previewLayer)
                
                DispatchQueue.global(qos: .background).async {
                    self.captureSession.startRunning()
                }
            }
        } catch let error {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    private func setupUI() {
        // Navigation bar
        let navBarView = UIView()
        navBarView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBarView)
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .white
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        navBarView.addSubview(backButton)
        
        let titleLabel = UILabel()
        titleLabel.text = "Should I Eat?"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        navBarView.addSubview(titleLabel)
        
        // Camera overlay with scanning animation
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.clear
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)
        
        let scanFrame = UIView()
        scanFrame.layer.borderColor = UIColor.white.cgColor
        scanFrame.layer.borderWidth = 2
        scanFrame.layer.cornerRadius = 20
        scanFrame.backgroundColor = UIColor.clear
        scanFrame.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(scanFrame)
        
        // Bottom controls
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomView)
        
        let captureButton = UIButton(type: .custom)
        captureButton.backgroundColor = .white
        captureButton.layer.cornerRadius = 35
        captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(captureButton)
        
        let galleryButton = UIButton(type: .system)
        galleryButton.setImage(UIImage(systemName: "photo.on.rectangle"), for: .normal)
        galleryButton.tintColor = .white
        galleryButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        galleryButton.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
        galleryButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(galleryButton)
        
        let flashButton = UIButton(type: .system)
        flashButton.setImage(UIImage(systemName: "bolt.slash"), for: .normal)
        flashButton.tintColor = .white
        flashButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        flashButton.addTarget(self, action: #selector(toggleFlash), for: .touchUpInside)
        flashButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(flashButton)
        
        let scanLabel = UILabel()
        scanLabel.text = "Scan a Menu for Allergy Risks"
        scanLabel.textColor = .white
        scanLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        scanLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        scanLabel.textAlignment = .center
        scanLabel.layer.cornerRadius = 20
        scanLabel.clipsToBounds = true
        scanLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scanLabel)
        
        // Constraints
        NSLayoutConstraint.activate([
            // Navigation bar
            navBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBarView.heightAnchor.constraint(equalToConstant: 44),
            
            backButton.leadingAnchor.constraint(equalTo: navBarView.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.centerXAnchor.constraint(equalTo: navBarView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor),
            
            // Overlay
            overlayView.topAnchor.constraint(equalTo: navBarView.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            // Scan frame
            scanFrame.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            scanFrame.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            scanFrame.widthAnchor.constraint(equalToConstant: 280),
            scanFrame.heightAnchor.constraint(equalToConstant: 280),
            
            // Scan label
            scanLabel.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -20),
            scanLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanLabel.widthAnchor.constraint(equalToConstant: 240),
            scanLabel.heightAnchor.constraint(equalToConstant: 40),
            
            // Bottom view
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 140),
            
            // Capture button
            captureButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            captureButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 20),
            captureButton.widthAnchor.constraint(equalToConstant: 70),
            captureButton.heightAnchor.constraint(equalToConstant: 70),
            
            // Gallery button
            galleryButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 50),
            galleryButton.centerYAnchor.constraint(equalTo: captureButton.centerYAnchor),
            galleryButton.widthAnchor.constraint(equalToConstant: 40),
            galleryButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Flash button
            flashButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -50),
            flashButton.centerYAnchor.constraint(equalTo: captureButton.centerYAnchor),
            flashButton.widthAnchor.constraint(equalToConstant: 40),
            flashButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func backButtonTapped() {
        delegate?.didCancel()
    }
    
    @objc private func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @objc private func openGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc private func toggleFlash() {
        // Flash toggle implementation
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.layer.bounds
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else { return }
        
        delegate?.didCaptureImage(image)
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            delegate?.didSelectImageFromGallery(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}



#Preview {
    MainView()
}
