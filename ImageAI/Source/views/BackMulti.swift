import SwiftUI
import Kingfisher

struct BackMulti: View {
    @Binding var befoImage: UIImage?
    @Binding var imageUrl: URL?
    @Binding var styleId: Int
    let croppingOptions = CroppedPhotosPickerOptions(doneButtonTitle: "Select", doneButtonColor: .orange)
    
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                CroppedPhotosPicker(style: .default, options: croppingOptions, selection: $befoImage) { rect in
                    Logger.success("Did crop to rect: \(rect)")
                    imageUrl = nil
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
                    
                  CircleMulti(beforeImage: befoImage, styleId: styleId)
                    
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
