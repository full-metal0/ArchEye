import SwiftUI
import PhotosUI


struct ExploreView: View {
    @State private var image: Image?
    @State private var showingCustomCamera = false
    @State private var isStartDrawn = false
    @State private var inputImage: UIImage?
    @State private var progress: CGFloat = 0
    @State private var photoItem: PhotosPickerItem?
    @State private var statusBarPercentes = 0.0
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            VStack {
                HStack {
                    uploadPhotoButton
                    Spacer()
                    title
                    Spacer()
                    makePhotoButton
                }
                
                if let image = image {
                    image
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                        .frame(width: 250, height: 250, alignment: .center)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .stroke(.white, lineWidth: 0.2)
                                .shadow(color: .black, radius: 1)
                        )
                    
                    HStack {
                        
                        Text(label)
                            .font(.title2)
                            .foregroundColor(.black)
                            .shadow(color: Color(red: 197/255, green: 197/255, blue: 197/255), radius: 3, x: 5, y: -2)
                            .blur(radius: 0.2)
                            .padding()
                        
                        StatusBar(isStartDrawn: $isStartDrawn, statusPercent: $statusBarPercentes)
                    }
                }
                
                Spacer()
            }
            .padding(.top, 40)
            .padding(.vertical, 20)
            .padding(.horizontal, 10)
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
        .sheet(isPresented: $showingCustomCamera, onDismiss: loadImage) {
            CustomCameraView(image: $inputImage)
        }
        .onChange(of: photoItem) { _ in
            Task {
                if let data = try? await photoItem?.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        inputImage = uiImage
                        loadImage()
                        return
                    }
                }
            }
        }
    }
}

private extension ExploreView {
    
    func loadImage() {
        isStartDrawn = false
        guard let inputImage = inputImage else { return }
        viewModel.classifiedBuild(inputImage)
        image = Image(uiImage: inputImage)
        viewModel.images.append(image!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            statusBarPercentes = viewModel.resultPercents.values.max() ?? 0.0
            isStartDrawn = true
        }
    }
}


// MARK: - Background Gradient

private extension ExploreView {
    
    var backgroundGradient: some View {
        Rectangle()
            .animatableGradient(
                fromGradient: ColorTheme.lastTheme.gradient,
                toGradient: defaultTheme.gradient,
                progress: progress
            )
    }
    
    var defaultTheme: Theme {
        ColorTheme.yellowTheme
    }
}

// MARK: - Make Photo Button

private extension ExploreView {
    
    var makePhotoButton: some View {
        Button(
            action: { showingCustomCamera = true },
            label: { makePhotoButtonTitle }
        )
    }
    
    var makePhotoButtonTitle: some View {
        Image(systemName: "camera.viewfinder")
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 30)
            .foregroundColor(.black)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(
                        .shadow(.inner(color: Color(red: 197/255, green: 197/255, blue: 197/255), radius: 2, x: 1, y: 1))
                        .shadow(.inner(color: Color(red: 197/255, green: 197/255, blue: 197/255), radius: 2, x: -1, y: -1))
                    )
                    .foregroundColor(.white)
            }
    }
}

// MARK: - Upload Photo Button

private extension ExploreView {
    
    var uploadPhotoButton: some View {
        PhotosPicker(selection: $photoItem, matching: .images) {
            uploadPhotoButtonTitle
        }
    }
    
    var uploadPhotoButtonTitle: some View {
        Image(systemName: "photo.stack")
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 30)
            .foregroundColor(.black)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(
                        .shadow(.inner(color: Color(red: 197/255, green: 197/255, blue: 197/255), radius: 2, x: 1, y: 1))
                        .shadow(.inner(color: Color(red: 197/255, green: 197/255, blue: 197/255), radius: 2, x: -1, y: -1))
                    )
                    .foregroundColor(.white)
            }
    }
}

// MARK: - Titles

private extension ExploreView {
    
    var title: some View {
        Text("Explore with ArchEye")
            .font(.title)
            .foregroundColor(.black)
            .shadow(color: Color(red: 197/255, green: 197/255, blue: 197/255), radius: 3, x: 5, y: -2)
            .blur(radius: 0.2)
            .padding()
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

enum Styles: String {
    case baroque = "Барокко"
    case oldRussianArchitecture = "Древнерусская архитектура"
    case classicism = "Классицизм"
    case modern = "Модерн"
    case modernAndExperimental = "Современный и экспериментальный"
    case stalinistArchitecture = "Сталинская архитектура"
    case typicalSovietArchitecture = "Типовая советская архитектура"
}

// MARK: - Status Alerts

private extension ExploreView {
    
    var baroqueAlert: some View {
            Text("Baroque")
                .foregroundColor(.black)
                .bold()
    }
    
    var goodAlert: some View {
        VStack {
            Text("Good.")
                .foregroundColor(.black)
                .bold()
            Text("You're in great shape! You can devote training to individual muscle groups.").foregroundColor(.black)
        }
    }
    
    var mediumAlert: some View {
        VStack {
            Text("Medium.")
                .foregroundColor(.black)
                .bold()
            Text("There are strengths, but they must be protected! Pay attention to individual muscle groups, alternating this with flexibility exercises.").foregroundColor(.black)
        }
    }
    
    var badAlert: some View {
        VStack {
            Text("Bad.")
                .foregroundColor(.black)
                .bold()
            Text("You should avoid overly strenuous activities! Diversify your activities with coordination exercises, paying attention to different muscle groups.").foregroundColor(.black)
        }
    }
    
    var awfulAlert: some View {
        VStack {
            Text("Awful.")
                .foregroundColor(.black)
                .bold()
            Text("It's worth saving your energy! Continue to focus on your heart health and flexibility exercises!").foregroundColor(.black)
        }
    }
    
    var deadAlert: some View {
        VStack {
            Text("You are dead.")
                .foregroundColor(.black)
                .bold()
            Text("Rest, rest and more rest! Dedicate the day to recreational activities to fully restore your body!").foregroundColor(.black)
        }
    }
}
