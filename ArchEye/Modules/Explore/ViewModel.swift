import Foundation
import CoreML
import Vision
import SwiftUI

final class ViewModel: ObservableObject {
    
    private let model = try? Model()
    
    @Published var resultLabel = "undetected"
    @Published var resultPercents = [String:Double]()
    @Published var images = [Image]()
    
    func classifiedBuild(_ inputImage: UIImage) {
        DispatchQueue.global(qos: .userInitiated).async {
            let inputImageSize: CGFloat = 224.0
            let minLen = min(inputImage.size.width, inputImage.size.height)
            let resizedImage = inputImage.resize(to: CGSize(
                width: inputImageSize * inputImage.size.width / minLen,
                height: inputImageSize * inputImage.size.height / minLen
            ))
            let cropedToSquareImage = resizedImage.cropToSquare()
            
            guard let pixelBuffer = cropedToSquareImage?.pixelBuffer() else {
                fatalError()
            }
            
            guard let classifierOutput = try? self.model?.predictions(inputs: [ModelInput(image: pixelBuffer)]) else {
                fatalError()
            }
            
            DispatchQueue.main.async {
                self.resultLabel = classifierOutput[0].classLabel
                self.resultPercents = classifierOutput[0].probabilities
            }
        }
    }
}
