import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        (0..<count).contains(index) ? self[index] : nil
    }
}
