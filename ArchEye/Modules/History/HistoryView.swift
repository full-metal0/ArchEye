import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: ExploreViewModel
    
    var body: some View {
        VStack {
            title
            historyScrollView
            Spacer()
        }
        .background(
            Image("background3")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
    }
}

// MARK: - Title

private extension HistoryView {
    
    var title: some View {
        Text("History")
            .font(.custom("Futura-Bold", size: 24))
            .foregroundColor(.white.opacity(0.9))
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black.opacity(0.2))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white.opacity(0.7), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.8), radius: 5, x: 0, y: 2)
            .padding(.bottom, 60)
    }
}

// MARK: - History Scroll View

private extension HistoryView {
    
    var historyScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(viewModel.images.indices, id: \.self) { index in
                    let image = viewModel.images[index]
                    image
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                        .frame(width: 250, height: 250, alignment: .center)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .stroke(Color.white, lineWidth: 0.2)
                                .shadow(color: .black, radius: 1)
                        )
                        .onTapGesture {
                           
                        }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 10)
    }
}


