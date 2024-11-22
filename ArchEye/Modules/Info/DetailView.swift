import SwiftUI

struct DetailView: View {
    let architectureType: String

    var body: some View {
        VStack {
            Text("Details about \(architectureType)")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.black.opacity(0.6))
                )
                .shadow(color: .black.opacity(0.8), radius: 5, x: 0, y: 2)
            Spacer()
        }
        .padding()
        .background(
            Image("background2")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
    }
}
