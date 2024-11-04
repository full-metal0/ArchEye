import SwiftUI

struct ColorTheme {
    
    static var lastTheme = Theme(
        name: "yellow",
        gradient: Gradient(colors: [.white, .white, Color(hex: 0x748ce1).opacity(0.1)])
    )
    
    static let yellowTheme = Theme(
        name: "yellow",
        gradient: Gradient(colors: [.white, .white, Color(hex: 0x748ce1).opacity(0.1)])
    )

    static let blueTheme = Theme(
        name: "blue",
        gradient: Gradient(colors: [.white, .white, Color(hex: 0xFFB6C1).opacity(0.1)])
    )
    
    static let redTheme = Theme(
        name: "red",
        gradient: Gradient(colors: [.white, .white, Color(hex: 0xf6b26b).opacity(0.1)])
    )
}

struct Theme: Identifiable {
    let id = UUID()
    let name: String
    let gradient: Gradient
}

extension Theme: Equatable {
    static func == (lhs: Theme, rhs: Theme) -> Bool { lhs.id == rhs.id }
}
