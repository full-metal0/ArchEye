import SwiftUI
import PhotosUI

struct ExploreView: View {
    @State private var image: Image?
    @State private var showingCustomCamera = false
    @State private var inputImage: UIImage?
    @State private var progress: CGFloat = 0
    @State private var photoItem: PhotosPickerItem?
    @State private var statusBarPercentes = 0.0
    @State private var displayedPercent: Double = 0.0
    
    @State private var displayedLabelText: String = ""
    @State private var labelTimer: Timer?
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            upperButtons
            Spacer()
            analyzedPhoto
            Spacer()
            makePhotoButton
        }
        .padding(.top, 40)
        .padding(.vertical, 20)
        .padding(.bottom, 100)
        .background(
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
        .sheet(isPresented: $showingCustomCamera, onDismiss: loadImage) {
            CameraView(image: $inputImage)
        }
        .onChange(of: photoItem) { _ in
            handlePhotoChange()
        }
    }
}

// MARK: - Header

private extension ExploreView {
    
    var upperButtons: some View {
        HStack {
            uploadPhotoButton
            Spacer()
            title
            Spacer()
            sendPhotoButton
        }
        .padding(.horizontal, 10)
    }
}

// MARK: - Analyzed Photo

private extension ExploreView {
    
    @ViewBuilder
    var analyzedPhoto: some View {
        if let image = image {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .stroke(Color.black.opacity(0.8), lineWidth: 4)
                                .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 1).delay(0.2), value: image)
                    
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }.padding(.horizontal, 20)


            
            photoLabel
            
            percents
        }
    }
    
    var photoLabel: some View {
        HStack {
            Text(displayedLabelText)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.black.opacity(0.6))
                )
                .shadow(color: .black.opacity(0.8), radius: 5, x: 0, y: 2)
        }
        .padding(.top, 10)
    }
    
    var percents: some View {
        Text("\(Int(displayedPercent * 100.0))%")
            .font(.title3)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.black.opacity(0.6))
            )
            .shadow(color: .black.opacity(0.8), radius: 5, x: 0, y: 2)
            .padding(.top, 5)
    }
    
    var label: String {
        switch viewModel.resultLabel {
        case "Барокко": return "Baroque"
        case "Древнерусская архитектура": return "Old Russian Architecture"
        case "Классицизм": return "Classicism"
        case "Модерн": return "Modern"
        case "Современный и экспериментальный": return "Modern and Experimental"
        case "Сталинская архитектура": return "Stalinist Architecture"
        case "Типовая советская архитектура": return "Typical Soviet Architecture"
        default:
            return "Undetected"
        }
    }
}

// MARK: - Buttons

private extension ExploreView {
    
    var makePhotoButton: some View {
        ZStack {
            ProgressView(value: progress)
                .progressViewStyle(ExploreProgress())
            
            Button(
                action: { showingCustomCamera = true },
                label: { makeTitle }
            )
            .exploreButtonStyle()
        }
    }
    
    var makeTitle: some View {
        Image(systemName: "camera.viewfinder")
            .resizable()
            .frame(width: 35, height: 35)
    }
    
    var sendPhotoButton: some View {
        Button(
            action: { shareImage() },
            label: { sendTitle }
        )
        .exploreButtonStyle()
    }
    
    var sendTitle: some View {
        Image(systemName: "paperplane")
            .resizable()
            .frame(width: 30, height: 30)
    }
    
    var uploadPhotoButton: some View {
        PhotosPicker(selection: $photoItem, matching: .images) {
            uploadTitle
        }
        .exploreButtonStyle()
    }
    
    var uploadTitle: some View {
        Image(systemName: "photo.stack")
            .resizable()
            .frame(width: 30, height: 30)
    }
}

// MARK: - Button Style Modifier

private extension View {
    func exploreButtonStyle() -> some View {
        self.modifier(ExploreButton())
    }
}

// MARK: - Percent Animation

private extension ExploreView {
    func startAnimatingPercent() {
        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            withAnimation(.linear(duration: 0.04)) {
                if displayedPercent < statusBarPercentes {
                    displayedPercent += 0.01
                } else {
                    displayedPercent = statusBarPercentes
                    timer.invalidate()
                }
            }
        }
    }
}

// MARK: - Typing Animation

private extension ExploreView {
    func startTypingAnimation() {
        labelTimer?.invalidate()
        displayedLabelText = ""
        
        DispatchQueue.global().async {
            let fullText = label
            for (index, character) in fullText.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                    displayedLabelText.append(character)
                }
            }
        }
    }
}

// MARK: - Load Image Action

private extension ExploreView {
    func loadImage() {
        guard let inputImage = inputImage else { return }
        viewModel.classifiedBuild(inputImage)
        image = Image(uiImage: inputImage)
        viewModel.images.append(image!)
        statusBarPercentes = 0.0
        progress = 0.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            statusBarPercentes = viewModel.resultPercents.values.max() ?? 0.0
            withAnimation(.easeOut(duration: 1).delay(0.1)) {
                progress = statusBarPercentes
                displayedPercent = 0.0
            }
            startTypingAnimation()
            startAnimatingPercent()
        }
    }
}

// MARK: - Share Image Action

private extension ExploreView {
    func shareImage() {
        guard let inputImage = inputImage else { return }
        let activityController = UIActivityViewController(activityItems: [inputImage], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityController, animated: true, completion: nil)
        }
    }
}

// MARK: - Handle Photo Changes Action

private extension ExploreView {
    func handlePhotoChange() {
        Task {
            if let data = try? await photoItem?.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    inputImage = uiImage
                    loadImage()
                }
            }
        }
    }
}


// MARK: - Titles

private extension ExploreView {
    
    var title: some View {
        Text("Explore with ArchEye")
            .font(.custom("Futura-Bold", size: 24))
            .foregroundColor(.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black.opacity(0.2))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.8), radius: 5, x: 0, y: 2)
    }
}
