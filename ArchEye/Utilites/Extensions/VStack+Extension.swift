import SwiftUI

extension VStack {
     init(alignment: HorizontalAlignment = .center, @ViewBuilder content: () -> Content) {
        self.init(alignment: alignment, spacing: 0, content: content)
    }
}
