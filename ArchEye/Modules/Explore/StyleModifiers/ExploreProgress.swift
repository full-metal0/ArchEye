import SwiftUI

struct ExploreProgress: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: CGFloat(configuration.fractionCompleted ?? 0))
                .stroke(Color.purple, lineWidth: 8)
                .rotationEffect(Angle(degrees: -90))
                .frame(width: 65, height: 65)
        }
    }
}
