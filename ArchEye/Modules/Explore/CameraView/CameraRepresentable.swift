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
}

final class Coordinator: NSObject, UINavigationControllerDelegate, @preconcurrency AVCapturePhotoCaptureDelegate {
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
