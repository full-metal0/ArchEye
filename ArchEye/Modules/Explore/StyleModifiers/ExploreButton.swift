import SwiftUI

struct ExploreButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding(15)
            .background {
                Circle()
                    .fill(Color.black.opacity(0.5))
                    .overlay(
                        Circle().stroke(Color.purple, lineWidth: 1)
                    )
            }
            .shadow(color: .black.opacity(0.8), radius: 5, x: 0, y: 2)
    }
}
