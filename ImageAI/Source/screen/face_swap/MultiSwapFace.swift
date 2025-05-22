
import SwiftUI
import Kingfisher
import PhotosUI

struct MultiSwapFace: View {
    @EnvironmentObject var router: Router
    @ObservedObject var enhanceViewModel: EnhanceRestoreViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var currentPopup: PopupType? = nil
    @StateObject private var multi = MultiFace(Datamultiface: dsMultiface)
    @State private var befoImage: UIImage? = nil
    @State private var imageUrl: URL? = nil
    @State private var selectionImage: UIImage? = nil
    @State private var styleId: Int = 0
    @State private var faceImages: [UIImage?] = []
    
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView {
                VStack {
                    BackMulti (
                        enhanceViewModel: enhanceViewModel,
                        befoImage: $befoImage,
                        selectionImage: $selectionImage,
                        imageUrl: $imageUrl,
                        styleId: $styleId,
                        faceImages: $faceImages
                    )
                    
                    Text("abc_Avatar_style")
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(5)
                        .bold()
                }
                
                styleSelectionScrollView()
                
                buttonFaceSwap()
                
            }
        }
        .popup(isPresented: Binding (
            get: { currentPopup?.isVisible ?? false},
            set: { _ in currentPopup = nil }
        )) {
            if currentPopup?.isImage == true {
                ToastBottomCustom (localizedKeyTitle: "noti_select_image")
                    .padding(.horizontal, UIConstants.Padding.medium)
            }
        } customize: {
            $0.type(.floater()).position(.bottom).autohideIn(2)
        }
        .onChange(of: enhanceViewModel.state.data) { _, newValue in
            guard let origin = newValue?.first?.origin,
                  let befoImage = befoImage else {
                return
            }
            Task {
                let currentDate = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let formattedDate = dateFormatter.string(from: currentDate)
                
                let imageUser = ImageUser.Builder()
                    .setId(-1)
                    .setPrompt(saveImageToDocuments(image: befoImage) ?? "")
                    .setDate(formattedDate)
                    .setStyleId(styleId)
                    .setImageUrl(origin)
                    .setId(7)
                    .build()
                await userViewModel.addImage(imageUser)
            }
            
            let request = MultiSFace(original: "", images: [])
            
            enhanceViewModel.cleanState()
            router.navigateTo(.result_multiface(befoImage, nil, request, false, origin, false))
        }
    }
    
    @ViewBuilder
    func styleSelectionScrollView() -> some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(dsMultiface, id: \.id) { item in
                    Button {
                        befoImage = nil
                        imageUrl = URL(string: item.imageName)
                        styleId = item.id
                    }label: {
                        ZStack {
                            KFImage(URL(string: item.imageName))
                                .placeholder {
                                    ShimmerEffect().cornerRadius(UIConstants.CornerRadius.large)
                                }
                                .loadDiskFileSynchronously()
                                .cacheMemoryOnly()
                                .resizable()
                                .frame(width: 105, height: 120)
                                .cornerRadius(UIConstants.CornerRadius.large)
                            
                            if styleId == item.id {
                                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.large)
                                    .strokeBorder(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                .Color.colorBlueStart,
                                                .Color.colorControlSelected
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        lineWidth: 4
                                    )
                                    .frame(width: 105, height: 120)
                            }
                        }
                        .overlay (
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Text(localizedKey: "abc_try")
                                        .font(.system(size: UIConstants.Padding.medium, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: UIConstants.sizeTry,
                                               height: UIConstants.sizeTry)
                                        .background(Circle()
                                            .fill(Color(.Color.colorTextSelected)))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(UIConstants.Padding.paddingTry)
                            }
                        )
                    }
                }
            }
        }
    }
    
    func buttonFaceSwap() -> some View {
        FaceSwapButtonView (
            isShowButton: befoImage != nil && (!faceImages.isEmpty || selectionImage != nil || imageUrl != nil),
            actionButton: {
                guard let befoImage = befoImage else {
                    currentPopup = .image
                    return
                }

                Task {
                    var swapFaces: [UIImage] = []

                    if !faceImages.isEmpty {
                        swapFaces = faceImages.compactMap { $0 }
                    } else if let selectionImage = selectionImage  {
                        swapFaces = [selectionImage]
                    }
                    else if let imageUrl = imageUrl, let loaded = await loadImage(from: imageUrl) {
                        swapFaces = [loaded]
                    }

                    guard !swapFaces.isEmpty else {
                        currentPopup = .image
                        return
                    }

                    await enhanceViewModel.fetchCreateImages(origin: befoImage, swapFaces: swapFaces)
                    
                }
            }
        )
    }

    func loadImage(from url: URL) async -> UIImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            print("Lỗi load ảnh từ URL: \(error)")
            return nil
        }
    }
    
}

#Preview {
    MultiSwapFace(enhanceViewModel: EnhanceRestoreViewModel(repository: AppDIContainer.shared.appRepository))
}
