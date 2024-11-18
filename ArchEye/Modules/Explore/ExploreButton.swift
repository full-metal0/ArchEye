import SwiftUI

struct ButtonStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding(15)
            .background {
                Circle()
                    .fill(Color.gray.opacity(0.5))
                    .overlay(
                        Circle().stroke(Color.purple, lineWidth: 1)
                    )
            }
    }
}
