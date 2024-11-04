import SwiftUI

struct TabItem: View {
    
    let imageName: String
    let title: String
    let isActive: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            Spacer()
            Image(systemName: imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.black)
                .frame(width: 20, height: 20)
            if isActive {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(isActive ? .black : .clear)
            }
            Spacer()
        }
        .frame(width: isActive ? .infinity : 60, height: 60)
        .background(
            Capsule()
                .stroke(isActive ? .black : .clear, lineWidth: 2)
                .blur(radius: 1)
        )
        .cornerRadius(30)
    }
}

