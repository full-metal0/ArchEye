import Foundation
import SwiftUI
import CoreData

final class ImageStorageViewModel: ObservableObject {
    
    @Published var images = [Image]()
    
    private let viewContext = PersistenceController.shared.container.viewContext
}

extension ImageStorageViewModel {
    
    func saveImage(_ image: UIImage) {
        guard let data = image.pngData() else { return }
        let filename = UUID().uuidString + ".png"
        let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
        
        do {
            try data.write(to: fileURL)
            
            let storedImage = StoredImage(context: viewContext)
            storedImage.id = UUID()
            storedImage.imagePath = filename
            
            try viewContext.save()
            loadImages()
        } catch {}
    }
    
    func loadImages() {
        let request: NSFetchRequest<StoredImage> = StoredImage.fetchRequest()
        
        do {
            let storedImages = try viewContext.fetch(request)
            images = storedImages.compactMap { storedImage in
                if let imagePath = storedImage.imagePath {
                    let fileURL = getDocumentsDirectory().appendingPathComponent(imagePath)
                    if let uiImage = UIImage(contentsOfFile: fileURL.path) {
                        return Image(uiImage: uiImage)
                    }
                }
                return nil
            }
        } catch {}
    }
    
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
