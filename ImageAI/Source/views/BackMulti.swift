import SwiftUI
import Kingfisher

struct BackMulti: View {
    @ObservedObject var enhanceViewModel: EnhanceRestoreViewModel
    @Binding var befoImage: UIImage?
    @Binding var imageUrl: URL?
    @Binding var styleId: Int
    let croppingOptions = CroppedPhotosPickerOptions(doneButtonTitle: "Select", doneButtonColor: .orange)
    @State private var selectedParenId: Int?
    @StateObject var face = Facecrop(Datafacecrop: dsFaceCrop)
    @State private var showFaces: Bool = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
               
                CroppedPhotosPicker(style: .default, options: croppingOptions, selection: $befoImage) { rect in
                    Logger.success("Did crop to rect: \(rect)")
                    imageUrl = nil
                    styleId = 0
                    if let img = befoImage {
                        Task {
                            await enhanceViewModel.fetchCreateImages(facecropCreateRequest: FaceCrop(imageName: []), uiImage: img)
                        }
                    }

                } didCancel: {
                    Logger.success("Did cancel")
                } label: {
                    ZStack {
                        if let newImage = befoImage {
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
                    .overlay {
                        if befoImage != nil || imageUrl != nil {
                            ZStack {
                                if let newbefoImage = befoImage {
                                    Image(uiImage: newbefoImage)
                                        .resizable()
                                        .frame(width: 300, height: 300)
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(UIConstants.CornerRadius.extraLarge)
                                        .clipped()
                                } else if let newimageUrl = imageUrl {
                                    KFImage(newimageUrl)
                                        .resizable()
                                        .frame(width: 300, height: 300)
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(UIConstants.CornerRadius.extraLarge)
                                        .clipped()
                                }
                                
                                VStack {
                                    HStack {
                                        Spacer()
                                        Button {
                                            befoImage = nil
                                            imageUrl = nil
                                            styleId = 0
                                        } label: {
                                            Image("ic_close")
                                                .resizable()
                                                .renderingMode(.template)
                                                .foregroundStyle(Color.white)
                                                .frame(width: UIConstants.sizeIconSmall, height: UIConstants.sizeIconSmall)
                                                .padding(UIConstants.Padding.large)
                                                .background(RoundedRectangle(cornerRadius: UIConstants.CornerRadius.extraLarge)
                                                    .fill(Color.gray.opacity(0.3)))
                                        }
                                        .padding(UIConstants.Padding.superSmall)
                                        .frame(width: UIConstants.actionBarSize, height: UIConstants.actionBarSize)
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                
                if befoImage != nil || imageUrl != nil {
                    Text("Add Face")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 17))
                        .padding(.top, 10)
                        .bold()
                    
                    let filteredFaces: [StyleFaceCrop] = {
                        if befoImage != nil {
                            return dsFaceCrop.filter { $0.parentId == 0 || $0.parentId == nil}
                        } else {
                            return dsFaceCrop.filter { $0.parentId == styleId }
                        }
                    }()
                    
                        ScrollView(.horizontal) {
                            HStack(spacing: 0) {
                                ForEach(filteredFaces, id: \.id) { face in
                                    VStack(spacing: 8) {
                                        CircleMulti(beforeImage: befoImage, styleId: styleId)
                                            .padding()
                                        
                                        Image(systemName: "arrow.down")
                                            .foregroundColor(.white)
                                            .padding(.vertical, 4)
                                        
                                        KFImage(URL(string: face.imageName))
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                            .clipShape(Circle())
                                    }
                                    .padding(.horizontal, 4)
                                }
                            }
                        }
                }
            }
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
