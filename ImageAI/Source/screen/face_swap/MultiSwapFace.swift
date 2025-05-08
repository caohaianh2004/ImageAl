//
//  FaceSwapMuti.swift
//  ImageAI
//
//  Created by Boss on 23/04/2025.
//

import SwiftUI
import Kingfisher
import PhotosUI

struct MultiSwapFace: View {
    @EnvironmentObject var router: Router
    @ObservedObject var enhanceViewModel: EnhanceRestoreViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var multi = MultiFace(Datamultiface: dsMultiface)
    @State private var befoImage: UIImage? = nil
    @State private var imageUrl: URL? = nil
    @State private var styleId: Int = 0
    @State private var currentPopup: PopupType? = nil
    @State private var faceImage: [UIImage] = []
    @State private var isselectedPhotto = false
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView {
                VStack {
                    BackMulti (
                        befoImage: $befoImage,
                        imageUrl: $imageUrl,
                        styleId: $styleId
                    )
                    
                    Text("abc_Avatar_style")
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(5)
                        .bold()
                }
                
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
                
                FaceSwapButtonView (
                    isShowButton: befoImage != nil && imageUrl != nil,
                    actionButton: {
                        guard let befoImage = befoImage, imageUrl != imageUrl else {
                            currentPopup = .image
                            return
                        }
                        Task {
                            
                        }
                    }
                )
            }
        }
    }
}

#Preview {
    MultiSwapFace(enhanceViewModel: EnhanceRestoreViewModel(repository: AppDIContainer.shared.appRepository))
}

