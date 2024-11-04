import SwiftUI

struct StatusBar: View {
    
    @Binding var isStartDrawn: Bool
    @Binding var statusPercent: Double
    
    var body: some View {
        ZStack {
            ring.frame(width: 50)
        }
        .animation(animation, value: isStartDrawn)
    }
}

private extension StatusBar {
    
    var ring: some View {
        Circle()
            .stroke(style: StrokeStyle(lineWidth: 8))
            .foregroundStyle(.tertiary.opacity(0.1))
            .blur(radius: 2)
            .overlay {
                Circle()
                    .trim(from: 0, to: isStartDrawn ? statusPercent : 0)
                    .stroke(
                        statusColor,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
            }
            .rotationEffect(.degrees(-90))
            .modifier(PercentageIndicator(pct: statusPercent))
    }
    
    var statusColor: AngularGradient {
        AngularGradient(
            gradient: Gradient(colors: [.black]),
            center: .center,
            startAngle: .zero,
            endAngle: .degrees(360)
        )
    }
    
    var animation: Animation {
        Animation
            .easeOut(duration: 3)
            .delay(0.5)
    }
}

struct PercentageIndicator: AnimatableModifier {
    var pct: CGFloat = 0
    
    var animatableData: CGFloat {
        get { pct }
        set { pct = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(LabelView(pct: pct))
    }
    
    
    struct LabelView: View {
        let pct: CGFloat
        
        var body: some View {
            Text("\(Int(pct * 100)) %")
                .fontWeight(.bold)
                .foregroundColor(.black)
        }
    }
}

