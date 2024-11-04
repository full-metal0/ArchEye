import SwiftUI
import Charts

struct HistoryView: View {
    
    @State private var progress: CGFloat = 0
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            VStack {
                
                Text("History")
                    .font(.title)
                    .foregroundColor(.black)
                    .shadow(color: Color(red: 197/255, green: 197/255, blue: 197/255), radius: 3, x: 5, y: -2)
                    .blur(radius: 0.2)
                    .padding()
                    .padding(.trailing, 200)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        Image("118996")
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                            .frame(width: 250, height: 250, alignment: .center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .stroke(.white, lineWidth: 0.2)
                                    .shadow(color: .black, radius: 1)
                            )
                        Image("120013")
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                            .frame(width: 250, height: 250, alignment: .center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .stroke(.white, lineWidth: 0.2)
                                    .shadow(color: .black, radius: 1)
                            )
                        
                    }
                }
            }
            .padding(.bottom, 250)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
        .onAppear {
            withAnimation(.linear(duration: 1.0)) {
                progress = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                ColorTheme.lastTheme = defaultTheme
            }
        }
        .onDisappear {
            progress = 0.0
        }
    }
}

// MARK: - Background Gradient

private extension HistoryView {
    
    var backgroundGradient: some View {
        Rectangle()
            .animatableGradient(
                fromGradient: ColorTheme.lastTheme.gradient,
                toGradient: defaultTheme.gradient,
                progress: progress
            )
    }
    
    var defaultTheme: Theme {
        ColorTheme.blueTheme
    }
}
