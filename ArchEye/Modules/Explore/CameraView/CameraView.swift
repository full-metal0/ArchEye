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
