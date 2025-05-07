//
//  BackUpload.swift
//  ImageAI
//
//  Created by Boss on 22/04/2025.
//

import SwiftUI
import Kingfisher

struct BackUpload: View {
    @Binding  var selectionImage : UIImage?
    @Binding var imageUrl: URL?
    @Binding var styleId: Int
    let croppingOptions = CroppedPhotosPickerOptions(doneButtonTitle: "Select",doneButtonColor: .orange)
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                CroppedPhotosPicker(style: .default, options: croppingOptions, selection: $selectionImage) { rect in
                    Logger.success("Did crop to rect: \(rect)")
                    imageUrl = nil
                } didCancel: {
                    Logger.success("Did cancel")
                } label: {
                    ZStack {
                        if let newImage = selectionImage {
                            Image(uiImage: newImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 180, height: 250)
                                .cornerRadius(UIConstants.CornerRadius.extraLarge)
                                .clipped()
                        } else if let imageUrl = imageUrl {
                            KFImage.url(imageUrl)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 180, height: 250)
                                .cornerRadius(UIConstants.CornerRadius.extraLarge)
                                .clipped()
                        } else {
                            backupload()
                        }
                    }.overlay {
                        if selectionImage != nil || imageUrl != nil {
                            ZStack {
                                if let selectedImage = selectionImage {
                                    Image(uiImage: selectedImage)
                                        .resizable()
                                        .aspectRatio( contentMode: .fit)
                                        .frame(width: 180, height: 250)
                                        .cornerRadius(UIConstants.CornerRadius.extraLarge)
                                        .clipped()
                                } else if let url = imageUrl {
                                    KFImage.url(url)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 180, height: 250)
                                        .cornerRadius(UIConstants.CornerRadius.extraLarge)
                                        .clipped()
                                }
                                
                                VStack {
                                    HStack {
                                        Spacer()
                                        Button {
                                            selectionImage = nil
                                            imageUrl = nil
                                            styleId = 0
                                        } label: {
                                            Image("ic_close")
                                                .resizable()
                                                .renderingMode(.template)
                                                .foregroundColor(.white)
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
                        }
                    }
                }
            }
        }
    }
}

func backupload() -> some View {
    ZStack {
        Color(red: 30/255, green: 40/255, blue: 70/255)
            .frame(width: 180,height: 250)
            .cornerRadius(15)
        VStack {
            Spacer()
            Image(systemName: "sparkles")
                .font(.system(size: 25))
                .foregroundStyle(Color.blue)
            
            Text(localizedKey: "abc_upload")
                .foregroundStyle(Color.white)
                .bold()
                .padding(.bottom, 12)
                .font(.system(size: UIConstants.TextSize.sizeupload))
        }
    }
    .frame(width: 180, height: 250)
}



//#Preview {
//    BackUpload()
//}


