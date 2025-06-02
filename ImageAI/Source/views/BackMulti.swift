import SwiftUI
import Kingfisher

struct BackMulti: View {
    @ObservedObject var enhanceViewModel: EnhanceRestoreViewModel
    @Binding var befoImage: UIImage?
    @Binding var selectionImage: UIImage?
    @Binding var imageUrl: URL?
    @Binding var styleId: Int
    @State private var selectedFaceIndex: Int? = nil


    let croppingOptions = CroppedPhotosPickerOptions(doneButtonTitle: "Select", doneButtonColor: .orange)
    @State private var filteredFaces = [StyleFaceCrop]()
    @Binding var faceImages: [UIImage?] 
    @State private var isLoading = false

    var body: some View {
        ZStack {
            BackgroundView()

            VStack {
                CroppedPhotosPicker(style: .default, options: croppingOptions, selection: $selectionImage) { rect in
                    Logger.success("Did crop to rect: \(rect)")
                    imageUrl = nil
                    styleId = 0
                } didCancel: {
                    Logger.success("Did cancel")
                } label: {
                    selectionLabelView()
                }

                if !filteredFaces.isEmpty {
                    filteredFaceListView()
                }

                Spacer()
            }
            .padding()
        }
        .onChange(of: selectionImage) { _, newImage in
            if let image = newImage {
                befoImage = image
                isLoading = true
                Task {
                    await enhanceViewModel.fetchCreateImages(
                        facecropCreateRequest: FaceCrop(images: []),
                        uiImage: image
                    )
                    isLoading = false
                }
            }
        }
        .onChange(of: imageUrl) { _, newUrl in
            guard let url = newUrl else { return }

            let filtered = dsFaceCrop.filter { $0.parentId == styleId }

            if styleId > 0, !filtered.isEmpty {
                filteredFaces = filtered
                selectionImage = nil

                Task {
                    do {
                        let (data, _) = try await URLSession.shared.data(from: url)
                        if let uiImage = UIImage(data: data) {
                            befoImage = uiImage
                            
                        } else {
                            print("Không thể tạo UIImage từ data")
                        }
                    } catch {
                        print("Lỗi khi tải ảnh từ URL: \(error.localizedDescription)")
                    }
                }
                return
            }

            Task {
                isLoading = true
                defer { isLoading = false }
                
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let uiImage = UIImage(data: data) {
                        befoImage = uiImage
                        selectionImage = nil

                        await enhanceViewModel.fetchCreateImages(
                            facecropCreateRequest: FaceCrop(images: []),
                            uiImage: uiImage
                        )
                    } else {
                        print("Không thể tạo UIImage từ data")
                    }
                } catch {
                    print("Lỗi khi tải ảnh từ URL: \(error.localizedDescription)")
                }
            }
        }
        .onChange(of: enhanceViewModel.state.data) { _, newData in
            guard let origin = newData?.enumerated().map({ (i, item) in
                StyleFaceCrop(id: i, imageName: item.origin, parentId: 0)
            }) else {
                return
            }
            
            filteredFaces = origin

            faceImages = Array(repeating: nil, count: filteredFaces.count)
        }

        .onChange(of: styleId) { _, newId in
            if selectionImage == nil {
                filteredFaces = dsFaceCrop.filter { $0.parentId == newId }
                faceImages = Array(repeating: nil, count: filteredFaces.count)
            }
        }
    }


    @ViewBuilder
    func selectionLabelView() -> some View {
        ZStack {
            selectionImageContent()
            
            if isLoading {
                Loading()
                    .frame(width: 100, height: 100)
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(12)
            }
        }
        .overlay(alignment: .topTrailing) {
            if selectionImage != nil || imageUrl != nil {
                closeButtonOverlay()
            }
        }
    }

    @ViewBuilder
    func selectionImageContent() -> some View {
        if let newImage = selectionImage {
            Image(uiImage: newImage)
                .resizable()
                .frame(width: 300, height: 300)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(UIConstants.CornerRadius.extraLarge)
                .clipped()
        } else if let imageUrl = imageUrl {
            KFImage(imageUrl)
                .resizable()
                .frame(width: 300, height: 300)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(UIConstants.CornerRadius.extraLarge)
                .clipped()
        } else {
            backButton()
        }
    }

    @ViewBuilder
    func closeButtonOverlay() -> some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    selectionImage = nil
                    imageUrl = nil
                    styleId = 0
                    filteredFaces = []
                    faceImages = []
                } label: {
                    Image("ic_close")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.white)
                        .frame(width: UIConstants.sizeIconSmall, height: UIConstants.sizeIconSmall)
                        .padding(UIConstants.Padding.large)
                        .background(
                            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.extraLarge)
                                .fill(Color.gray.opacity(0.3))
                        )
                }
                .padding(UIConstants.Padding.superSmall)
                .frame(width: UIConstants.actionBarSize, height: UIConstants.actionBarSize)
            }
            Spacer()
        }
    }

    @ViewBuilder
    func filteredFaceListView() -> some View {
        VStack {
            Text("Add Face")
                .foregroundStyle(Color.white)
                .font(.system(size: 17))
                .padding(.top, 10)
                .bold()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(filteredFaces.indices, id: \.self) { index in
                        let face = filteredFaces[index]
                        faceView(for: face, index: index)
                    }
                }
            }
        }
    }

    @ViewBuilder
    func faceView(for face: StyleFaceCrop, index: Int) -> some View {
        VStack(spacing: 8) {
            CircleMulti (
                    beforeImage: Binding(
                        get: { faceImages.indices.contains(index) ? faceImages[index] : nil },
                        set: { newValue in
                            if faceImages.indices.contains(index) {
                                faceImages[index] = newValue
                            }
                        }
                    ),
                    onImageChanged: { newImage in
                        if faceImages.indices.contains(index) {
                            faceImages[index] = newImage
                        }
                    }
                )
                .frame(width: 80, height: 80)
                .padding(12)

            Image(systemName: "arrow.down")
                .foregroundColor(.white)

            KFImage(URL(string: face.imageName))
                .resizable()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
        }
    }
}

func backButton() -> some View {
    ZStack {
        VStack {
            Image(systemName: "sparkles")
                .foregroundColor(.blue)
                .font(.system(size: UIConstants.TextSize.sizesparkles))
            Text(localizedKey: "abc_upload")
                .font(.system(size: UIConstants.TextSize.sizeupload))
                .bold()
                .padding(1)
            Text(localizedKey: "abc_multi")
                .foregroundStyle(Color.white)
                .font(.system(size: UIConstants.TextSize.sizeupload))
                .bold()
        }
        Rectangle()
            .stroke(style: StrokeStyle(lineWidth: 8, dash: [10]))
            .foregroundColor(.blue)
            .frame(width: 300, height: 300)
            .cornerRadius(UIConstants.CornerRadius.extraLarge)
    }
}
