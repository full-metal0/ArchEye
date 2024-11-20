import Foundation
import CoreML
import Vision
import SwiftUI

final class ExploreViewModel: ObservableObject {
    
    private let model = try? Model()
    
    @Published var resultLabel = "undetected"
    @Published var resultPercents = [String:Double]()
    @Published var images = [Image]()
}

extension ExploreViewModel {
    
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
                self.resultLabel = self.getEngLabel(classifierOutput[0].classLabel)
                self.resultPercents = classifierOutput[0].probabilities
            }
        }
    }
    
    func toIntPercents(_ value: Double) -> String {
        "\(Int(value * 100.0))%"
    }
}

private extension ExploreViewModel {
    
    func getEngLabel(_ label: String) -> String {
        switch label {
        case "Барокко": return "Baroque"
        case "Древнерусская архитектура": return "Old Russian Architecture"
        case "Классицизм": return "Classicism"
        case "Модерн": return "Modern"
        case "Современный и экспериментальный": return "Modern and Experimental"
        case "Сталинская архитектура": return "Stalin's Architecture"
        case "Типовая советская архитектура": return "Typical Soviet Architecture"
        default:
            return "Undetected"
        }
    }
}
