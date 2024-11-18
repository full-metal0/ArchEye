import SwiftUI
import PhotosUI

struct ExploreView: View {
    @State private var image: Image?
    @State private var showingCustomCamera = false
    @State private var inputImage: UIImage?
    @State private var progress: CGFloat = 0
    @State private var photoItem: PhotosPickerItem?
    @State private var statusBarPercentes = 0.0
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            upperButtons
            Spacer()
            analyziedPhoto
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
        .onAppear {
            progress = 0.0
        }
        .onDisappear {
            progress = 0.0
        }
        .sheet(isPresented: $showingCustomCamera, onDismiss: loadImage) {
            CustomCameraView(image: $inputImage)
        }
        .onChange(of: photoItem) { _ in
            handlePhotoChange()
        }
    }
}

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
    
    @ViewBuilder
    var analyziedPhoto: some View {
        if let image = image {
            image
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                .frame(width: 300, height: 300, alignment: .center)
                .aspectRatio(contentMode: .fit)
                .overlay(
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .stroke(Color.white, lineWidth: 4)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
                )
            
            HStack {
                Text(label)
                    .font(.title2)
                    .foregroundColor(.black)
                    .shadow(color: Color(red: 197/255, green: 197/255, blue: 197/255), radius: 3, x: 5, y: -2)
                    .blur(radius: 0.2)
                    .padding()
            }
        }
    }
}

// MARK: - Buttons

private extension ExploreView {
    
    var makePhotoButton: some View {
        ZStack {
            ProgressView(value: progress)
                .progressViewStyle(CircularProgressViewStyle())
            
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
        .onChange(of: photoItem) { _ in
            handlePhotoChange()
        }
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
        self.modifier(ButtonStyleModifier())
    }
}

// MARK: - Load Image Action

private extension ExploreView {
    func loadImage() {
        guard let inputImage = inputImage else { return }
        viewModel.classifiedBuild(inputImage)
        image = Image(uiImage: inputImage)
        viewModel.images.append(image!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            statusBarPercentes = viewModel.resultPercents.values.max() ?? 0.0
            withAnimation(.easeOut(duration: 3).delay(0.5)) {
                progress = 1.0
            }
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
                    withAnimation(.linear(duration: 1.0)) {
                        progress = 0.8
                    }
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
                    .fill(Color.gray.opacity(0.2))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 1)
            )
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

// MARK: Progress Style Modifier

struct CircularProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: CGFloat(configuration.fractionCompleted ?? 0))
                .stroke(Color.purple, lineWidth: 4)
                .rotationEffect(Angle(degrees: -90))
                .frame(width: 65, height: 65)
        }
    }
}
