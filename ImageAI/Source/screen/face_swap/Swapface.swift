//
//  Swap_face.swift
//  ImageAI
//
//  Created by Boss on 21/04/2025.
//

import SwiftUI
import Kingfisher

struct Swapface: View {
    @EnvironmentObject var router: Router
    @StateObject  var swap = SwapfaceModel(Dataswapface: dsSwapface)
    @State private var selectedStyle = ""
    @State private var styleId: Int = 0
    var groupGenden: [String] {
        Array(Set(dsSwapface.map{ $0.genden })).sorted()
    }
    @ObservedObject var enhanceViewModel: EnhanceRestoreViewModel
    @State private var currentPopup: PopupType? = nil
    @State private var imageUrl: URL? = nil
    @State private var selectionImage: UIImage? = nil
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var beforeImage: UIImage? 
    @State private var afterImage: UIImage?
    
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView {
                HStack {
                    VStack {
                        BackSwapface(beforeImage: $beforeImage)
                            .frame(height: UIConstants.sizefacestruction)
                        Text(localizedKey: "abc_upload_target_face")
                            .foregroundStyle(Color.white)
                            .font(.system(size: UIConstants.TextSize.swapface))
                            .bold()
                    }
                    
                    Image("ic_back")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(1, contentMode: .fit)
                        .bold()
                        .padding(UIConstants.Padding.medium)
                        .foregroundColor(.Color.colorPrimary)
                        .frame(height: UIConstants.sizeIconicback)
                        .rotationEffect(.degrees(180))
                    
                    BackUpload(selectionImage: $selectionImage, imageUrl: $imageUrl, styleId: $styleId)
                    
                    
                }
                
                Text(localizedKey: "abc_Avatar_style")
                    .font(.system(size: UIConstants.TextSize.avatarStyle, weight: .bold, design: .default))
                    .foregroundColor(.Color.colorPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                
                HStack {
                    Button {
                        withAnimation {
                            selectedStyle = ""
                        }
                    } label: {
                        Text(localizedKey: "abc_all")
                            .font(.system(size: UIConstants.TextSize.sizeall))
                            .bold()
                            .foregroundStyle(selectedStyle.isEmpty ? Color.white : Color.gray)
                            .frame(maxWidth: .infinity)
                            .overlay (
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(height: selectedStyle.isEmpty ? 2 : 0)
                                    .offset(y: 10),
                                alignment: .bottom
                            )
                    }
                    
                    ForEach(groupGenden, id: \.self) { genden in
                        Button {
                            selectedStyle = genden
                        } label: {
                            Text(genden.uppercased())
                                .foregroundStyle(selectedStyle == genden ? Color.white : Color.gray)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .font(.system(size: UIConstants.TextSize.sizeall))
                                .overlay(
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(height: selectedStyle == genden ? 2 : 0)
                                        .offset(y: 10),
                                    alignment: .bottom
                                )
                        }
                    }
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(filteredImage(), id: \.id) { item in
                            styleItemView(item: item)
                        }
                    }
                }

                buttonFaceSwap()
                
            }
        }.popup(isPresented: Binding(
            get: { currentPopup?.isVisible ?? false},
            set: {_ in currentPopup = nil}
        )) {
            if currentPopup?.isImage == true {
                ToastBottomCustom (
                    localizedKeyTitle: "noti_select_image"
                ).padding(.horizontal, UIConstants.Padding.medium)
            }
        } customize: {
            $0.type(.floater()).position(.bottom).autohideIn(2)
        }
        .onChange(of: enhanceViewModel.state.data) { _, newValue in
            guard let origin = newValue?.first?.origin,
                  let beforeImage = beforeImage else {
                return
            }
            Task {
                let currentDate = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let formattedDate = dateFormatter.string(from: currentDate)
                
                let imageUser = ImageUser.Builder()
                    .setId(-1)
                    .setPrompt(saveImageToDocuments(image: beforeImage) ?? "")
                    .setDate(formattedDate)
                    .setStyleId(styleId)
                    .setImageUrl(origin)
                    .setSizeCanvas(selectedStyle)
                    .setType(6)
                    .build()
                await userViewModel.addImage(imageUser)
            }
            let request = SwapFace(originals: [], faces: [])
            
            enhanceViewModel.cleanState()
            router.navigateTo(.result_swapface(beforeImage, nil, request, false, origin, false))
        }
    }
    
    func buttonFaceSwap() -> some View {
        FaceSwapButtonView(
            isShowButton: beforeImage != nil && (selectionImage != nil || imageUrl != nil),
            actionButton: {
                guard let beforeImage = beforeImage, (selectionImage != nil || imageUrl != nil) else {
                    currentPopup = .image
                    return
                }

                Task {
                    let faceImage: UIImage?
                    
                    if let selectionImage = selectionImage {
                        faceImage = selectionImage
                    } else if let imageUrl = imageUrl {
                        faceImage = await loadImage(from: imageUrl)
                    } else {
                        faceImage = nil
                    }
                    guard let faceImage else {
                        currentPopup = .image
                        return
                    }
                    await enhanceViewModel.fetchCreateImages(originalImage: beforeImage, faceImage: faceImage)
                }
            }
        )
    }
    
    func filteredImage() -> [StyleSwapFace] {
        if selectedStyle.isEmpty {
            return swap.swapface
        } else {
            return swap.swapface.filter { $0.genden == selectedStyle }
        }
    }
    
    func loadImage(from url: URL) async -> UIImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            print("❌ Error loading image from URL: \(error)")
            return nil
        }
    }

    
    @ViewBuilder
    func styleItemView(item: StyleSwapFace) -> some View {
        Button {
            styleId = item.id
            imageUrl = URL(string: item.imageName)
            selectionImage = nil
        } label: {
            ZStack {
                KFImage.url(URL(string: item.imageName))
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
            .padding(.top, 13)
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

#Preview {
    Swapface(enhanceViewModel: EnhanceRestoreViewModel(repository: AppDIContainer.shared.appRepository))
}

