import SwiftUI

struct InfoView: View {
    let architectureTypes = [
        "Барокко" : "barokko",
        "Сталинская архитектура" : "stalin",
        "Модерн" : "modern",
        "Современный и экспериментальный" : "modern and experimental",
        "Древнерусская" : "old_russian",
        "Типовая советская" : "soviet"
    ]
    
    @State private var selectedArchitecture: String?
    @State private var showDetail = false
    
    var body: some View {
        VStack {
            title
            
            ScrollView {
                VStack {
                    listOfStyles
                }
            }
            .padding(.bottom, safeAreaInsets?.bottom ?? 0)
            .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 2)
        }
        .background(
            Image("background5")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
        .sheet(isPresented: $showDetail, onDismiss: {
            selectedArchitecture = nil
        }) {
            if let selected = selectedArchitecture {
                DetailView(architectureType: selected)
            }
        }
    }
    
    var safeAreaInsets: UIEdgeInsets? {
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .windows.first?.safeAreaInsets
    }
}


// MARK: - Title

private extension InfoView {
    
    var title: some View {
        Text("Architecture Styles")
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

// MARK: - List Of Styles

private extension InfoView {
    
    var listOfStyles: some View {
        ForEach(architectureTypes.keys.sorted(), id: \.self) { key in
            listButton(key)
        }
    }
    
    func listButton(_ key: String) -> some View {
        Button(
            action: {
                selectedArchitecture = key
                showDetail = true
            },
            label: { listLabel(key) }
        ).padding(.vertical, 5)
        
    }
    
    func listLabel(_ key: String) -> some View {
        HStack {
            Image(architectureTypes[key] ?? "photo")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            
            Text(key)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .shadow(color: .black.opacity(0.8), radius: 5, x: 0, y: 2)
            
            Spacer()
        }
        .background(
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.black.opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .stroke(Color.purple.opacity(0.7), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.8), radius: 5, x: 0, y: 2)
    }
}

