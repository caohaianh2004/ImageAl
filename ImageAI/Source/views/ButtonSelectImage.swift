//
//  ButtonSelectImage.swift
//  ImageAI
//
//  Created by DoanhMac on 17/3/25.
//

import SwiftUI

struct ButtonSelectImage: View {
    @State private var selection: UIImage?
    let croppingOptions = CroppedPhotosPickerOptions(doneButtonTitle: "Select",doneButtonColor: .orange)
    @State var isShowPhoto : Bool
    let onSelectImage: (UIImage?) -> Void
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            CroppedPhotosPicker(style: .default, options: croppingOptions, selection: $selection) { rect in
                Logger.success("Did crop to rect: \(rect)")
            } didCancel: {
                Logger.success("Did cancel")
            } label: {
                HStack(alignment: .center) {
                    Image(systemName: "photo.badge.plus")
                        .renderingMode(.template)
                        .foregroundColor(.Color.colorTextSelected)
                        .frame(width: UIConstants.sizeIconMedium, height: UIConstants.sizeIconMedium)
                    Spacer().frame(width: UIConstants.Padding.large)
                    
                    Text(localizedKey: "upload_an_image")
                    
                }.frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, UIConstants.Padding.large)
                
            }.overlay {
                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.large)
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(colors: [.Color.colorBlueStart, .Color.colorControlSelected,.Color.colorBlueStart ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 2
                    )
            }
            
            if  selection != nil, isShowPhoto {
                let aspectRatio = selection!.size.width / selection!.size.height
                Image(uiImage: selection!)
                    .resizable()
                    .aspectRatio(aspectRatio, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedCorner(radius: UIConstants.CornerRadius.medium))
                    .overlay(content:  {
                        VStack {
                            HStack {
                                Spacer()
                                Button {
                                    selection = nil
                                    
                                } label: {
                                    Image("ic_close")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(.white)
                                        .font(.title2)
                                        .fontWeight(.regular)
                                        .padding(UIConstants.Padding.large)
                                        .background(
                                            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.extraLarge).fill(Color.gray.opacity(0.5))
                                        )
                                    
                                }
                                .padding(UIConstants.Padding.superSmall)
                                .frame(width: UIConstants.actionBarSize, height: UIConstants.actionBarSize)
                            }
                            Spacer()
                        }
                        
                    })
            }
        }
        .scaleEffect(isAnimating ? 1.01 : 0.98)
                .animation(
                    Animation.easeInOut(duration: 0.6)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )
                .onAppear {
                    isAnimating = true
                }
        .onChange(of: selection) { _,newImage in
           
                onSelectImage(newImage)
            
        }
    }
}

#Preview {
    ButtonSelectImage(
        isShowPhoto: true,
        onSelectImage: {_ in
            
        }
    )
}
