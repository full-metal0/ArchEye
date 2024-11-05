import SwiftUI

extension HStack {
    init(alignment: VerticalAlignment = .center, @ViewBuilder content: () -> Content) {
        self.init(alignment: alignment, spacing: 0, content: content)
    }
}
