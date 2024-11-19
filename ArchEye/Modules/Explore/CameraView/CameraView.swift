import SwiftUI
import AVFoundation

struct CameraView: View {
    
    @State private var didTapCapture: Bool = false
    
    @Binding var image: UIImage?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            CameraRepresentable(capturedImage: self.$image, shouldCaptureImage: $didTapCapture)
                .edgesIgnoringSafeArea(.all)
            
            captureButton
                .onTapGesture {
                    self.didTapCapture = true
                }
                .padding(.bottom, 20)
                
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
    }
}

// MARK: - Capture Button

private extension CameraView {
    
    var captureButton: some View {
        ZStack {
            Circle()
                .fill(Color.black.opacity(0.6))
                .frame(width: 70, height: 70)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                        .shadow(color: .black.opacity(0.8), radius: 5, x: 0, y: 2)
                )
            
            Image(systemName: "camera.viewfinder")
                .resizable()
                .frame(width: 35, height: 35)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Camera Representable

import SwiftUI
import AVFoundation

struct CameraRepresentable: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var capturedImage: UIImage?
    @Binding var shouldCaptureImage: Bool

    func makeUIViewController(context: Context) -> CameraController {
        let cameraController = CameraController()
        cameraController.delegate = context.coordinator
        return cameraController
    }

    func updateUIViewController(_ cameraController: CameraController, context: Context) {
        if shouldCaptureImage {
            cameraController.didTapRecord()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, @preconcurrency AVCapturePhotoCaptureDelegate {
        let parent: CameraRepresentable

        init(_ parent: CameraRepresentable) {
            self.parent = parent
        }

        @MainActor
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            parent.shouldCaptureImage = false

            if let _ = error {
                parent.presentationMode.wrappedValue.dismiss()
                return
            }

            guard let imageData = photo.fileDataRepresentation(),
                  let image = UIImage(data: imageData) else {
                parent.presentationMode.wrappedValue.dismiss()
                return
            }

            parent.capturedImage = image
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

