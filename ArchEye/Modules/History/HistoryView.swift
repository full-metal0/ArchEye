import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: ImageStorageViewModel
    
    var body: some View {
        VStack {
            title
            historyGridView
            Spacer()
        }
        .onAppear {
            viewModel.loadImages()
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
    }
}

// MARK: - Grid View

private extension HistoryView {
    
    var historyGridView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 10) {
                let reversedImages = viewModel.images.reversed()
                
                ForEach(Array(reversedImages).indices, id: \.self) { index in
                    if index % 2 == 0 {
                        HStack(spacing: 10) {
                            Array(reversedImages)[index]
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 170, height: 170)
                                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                                        .stroke(Color.white, lineWidth: 0.2)
                                        .shadow(color: .black, radius: 1)
                                )

                            if index + 1 < Array(reversedImages).count {
                                Array(reversedImages)[index + 1]
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 170, height: 170)
                                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                                            .stroke(Color.white, lineWidth: 0.2)
                                            .shadow(color: .black, radius: 1)
                                    )
                            } else {
                                Spacer()
                                    .frame(width: 170, height: 170)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 10)
    }
}
