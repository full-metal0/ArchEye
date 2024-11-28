import SwiftUI

final class InfoViewModel: ObservableObject {
    
    func loadDescriptions() -> [String: String]? {
        if let url = Bundle.main.url(forResource: "StylesDescriptions", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            return try? decoder.decode([String: String].self, from: data)
        }
        return nil
    }
}
