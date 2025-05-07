//
//  ResultSwapFace.swift
//  ImageAI
//
//  Created by Boss on 25/04/2025.
//

import SwiftUI

struct ResultSwapFace: View {
    @EnvironmentObject var router: Router
    @StateObject private var enhanceViewModel: EnhanceRestoreViewModel = AppDIContainer.shared.makeEnhanceRestoreViewModel()
    @EnvironmentObject var userViewModel: UserViewModel
    @State var imageBefore: UIImage? = nil
    @State var imageAfter: UIImage? = nil
    @State var showLogo: Bool = true
    @State var showAlertDowload: Bool = false
    @State var isShowSample:Bool = false
    @State var styleId: Int = 2
    @State var sizeCanvas: String = ""
    var restoreSwapFace: SwapFace
    var urlString: String
    var isHistory: Bool
    @State var isShowFeedBack: Bool = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: UIConstants.Padding.large) {
                ResultTopbar()
                SubResultView()
                ResultImage()
                SubImageResultView()
                if !isHistory {
                    SelectScaleViewResult()
                }
                Spacer()
            }.padding(.horizontal, UIConstants.Padding.medium)
            
            if enhanceViewModel.state.isLoading {
                DialogLoadingScreen(progress: Float(enhanceViewModel.state.progress)) {
                    enhanceViewModel.cancelFetchTask()
                }
            }
            if isShowFeedBack {
                DialogFeedBack {
                    isShowFeedBack = false
                } onSubmitDialog: { txtFeedBack in
                    if !txtFeedBack.isEmpty {
                        EmailHelper.shared.send(subject: LocalizationSystem.sharedInstance.localizedStringForKey(key: "menu_help_title", comment: ""),
                                                body: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key:"menu_help_detail", comment: "")) \(txtFeedBack)", to: ["phunggtheduy4896@gmail.com"])
                    }
                }
            }
        }.onAppear {
            if !urlString.isEmpty && imageAfter == nil {
                Task {
                    imageAfter = await loadImageFromURL(urlString)
                }
            }

        }.toast(isPresenting: $showAlertDowload) {
            AlertToast(type: .complete(.green), title: Optional("abc_download"), subTitle: Optional("abc_download_image"))
        }.onChange(of: enhanceViewModel.state.data) { _, newValue in
            guard let origin = newValue?.first?.origin,
                  let imageAfter = imageAfter else { return }
            
            if isHistory {
                Task {
                    let currentDate = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let formattedDate = dateFormatter.string(from: currentDate)
                    
                    let imageUser = ImageUser.Builder()
                        .setId(-1)
                        .setPrompt(saveImageToDocuments(image: imageBefore!) ?? "")
                        .setDate(formattedDate)
                        .setImageUrl(origin)
                        .setSizeCanvas(sizeCanvas)
                        .setType(3)
                        .build()
                    await userViewModel.addImage(imageUser)
                }
                
                let request = SwapFace(originals: [], faces: [])
                enhanceViewModel.cleanState()
                router.navigateTo(.result_swapface(imageAfter, nil, request, false, origin, false))
            }
        }
    }
    
    @ViewBuilder
    func SubResultView() -> some View {
        VStack(spacing: UIConstants.Padding.small) {
            HStack {
                Text(localizedKey: "size_image")
                    .bold()
                    .font(.system(size: UIConstants.TextSize.largeBody, weight: .bold, design: .default))
                    .foregroundColor(.white)
                
                if let imageBefore = imageBefore {
                    Text("\(imageBefore.size.width.description) x \(imageBefore.size.height.description)")
                        .bold()
                        .font(.system(size: UIConstants.TextSize.largeBody, weight: .bold, design: .default))
                        .foregroundColor(Color(.Color.colorTextSelected))
                }
                Spacer()
            }
            .padding(.horizontal, UIConstants.Padding.medium)
            
            if let imageAfter = imageAfter, !isShowSample {
                HStack {
                    Text(localizedKey: "size_new")
                        .bold()
                        .font(.system(size: UIConstants.TextSize.largeBody, weight: .bold, design: .default))
                        .foregroundStyle(Color.white)
                    
//                    Text("\(imageAfter.size.width.description) x \(imageAfter.size.height.description)")
//                        .bold()
//                        .font(.system(size: UIConstants.TextSize.largeBody, weight: .bold, design: .default))
//                        .foregroundStyle(Color(.Color.colorTextSelected))
                    
                    Spacer()
                }
                .padding(.horizontal, UIConstants.Padding.medium)
            }
        }
    }
    
    @ViewBuilder
    func SubImageResultView() -> some View {
        VStack(spacing: UIConstants.Padding.medium) {
            HStack {
                Text(sizeCanvas)
                    .bold()
                    .font(.system(size: UIConstants.TextSize.largeBody, weight: .medium, design: .default))
                    .fontWeight(.medium)
                    .foregroundColor(.Color.colorTextSelected)
                
                Spacer()
                
                if isHistory {
                    HStack {
                        Text(localizedKey: "abc_create_at")
                            .font(.system(size: UIConstants.TextSize.body, weight: .bold))
                            .fontWeight(.medium)
                            .foregroundColor(.gray.opacity(0.8))
                        
                        Text(": \(router.currentDate)")
                            .font(.system(size: UIConstants.TextSize.body, weight: .bold))
                            .fontWeight(.bold)
                            .foregroundColor(.Color.colorPrimary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal, UIConstants.Padding.medium)
        }
    }
    
    @ViewBuilder
    func ResultImage() -> some View {
        if imageAfter == nil || imageBefore == nil {
            VStack(alignment: .center) {
                ShimmerEffect()
                    .cornerRadius(UIConstants.CornerRadius.large)
                    .aspectRatio((imageBefore?.size.width ?? 1) / (imageAfter?.size.height ?? 1), contentMode: .fit)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.Color.colorAccent))
            .aspectRatio((imageBefore?.size.width ?? 1 ) / (imageAfter?.size.height ?? 1), contentMode: .fit)
            .cornerRadius(UIConstants.CornerRadius.large)
            .onTapGesture{}
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        if isHistory {
                            Button {
                                Task {
                                    guard let imageBefore = imageBefore else {
                                        return
                                    }
                                    await enhanceViewModel.fetchCreateImages(originalImage: imageBefore, faceImage: imageBefore)
                                }
                            } label: {
                                VStack(alignment: .leading) {
                                    Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
                                        .renderingMode(.template)
                                        .foregroundColor(.Color.colorPrimary)
                                        .padding(UIConstants.Padding.large)
                                        .background(
                                            Circle().fill(Color.gray.opacity(0.2))
                                        )
                                    Text(localizedKey: "abc_re_generate")
                                        .font(.system(size: UIConstants.TextSize.body, weight: .bold))
                                        .fontWeight(.medium)
                                        .foregroundColor(.Color.colorPrimary)
                                }
                            }
                        }
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            VStack(alignment: .trailing) {
                                Image(systemName: "square.and.arrow.up")
                                    .renderingMode(.template)
                                    .foregroundColor(.Color.colorPrimary)
                                    .padding(UIConstants.Padding.large)
                                    .background(
                                        Circle().fill(Color.gray.opacity(0.2))
                                    )
                                Text(localizedKey: "abc_feedback")
                                    .font(.system(size: UIConstants.TextSize.body, weight: .bold))
                                    .fontWeight(.medium)
                                    .foregroundColor(.Color.colorPrimary)
                            }
                        }
                    }
                    .padding(UIConstants.Padding.large)
                }
            )
        } else {
            ZStack {
                ImageComparisonView (
                    beforeUIImage: imageBefore,
                    afterUIImage: imageAfter,
                    beforeText: "abc_before",
                    afterText: "abc_after",
                    showText: true,
                    showIcon: true,
                    cornerRadius: 12,
                    isSelected: false,
                    actionGetBefore: { UIImage in},
                    actionGetAfter: {UIImage in}
                )
                .aspectRatio((imageBefore?.size.width ?? 1) / (imageBefore?.size.height ?? 1), contentMode: .fit)
                .cornerRadius(UIConstants.CornerRadius.large)
                .onTapGesture{}
                .overlay (
                    VStack {
                        Spacer()
                        HStack {
                            if isHistory {
                                Button {
                                    Task {
                                           guard let imageAfter = imageAfter else { return }
                                           await enhanceViewModel.fetchCreateImages(originalImage: imageAfter, faceImage: imageAfter)
                                       }
                                } label: {
                                    VStack(alignment: .leading) {
                                        Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
                                            .renderingMode(.template)
                                            .foregroundColor(.Color.colorPrimary)
                                            .padding(UIConstants.Padding.large)
                                            .background(
                                                Circle().fill(Color.gray.opacity(0.2))
                                            )
                                        Text(localizedKey: "abc_re_generate")
                                            .font(.system(size: UIConstants.TextSize.body, weight: .bold))
                                            .fontWeight(.medium)
                                            .foregroundColor(.Color.colorPrimary)
                                    }
                                }
                            }
                            Spacer()
                            
                            Button {
                                isShowFeedBack = true
                            }label: {
                                VStack(alignment: .trailing) {
                                    Image(systemName: "square.and.arrow.up")
                                        .renderingMode(.template)
                                        .foregroundColor(.Color.colorPrimary)
                                        .padding(UIConstants.Padding.large)
                                        .background(
                                            Circle().fill(Color.gray.opacity(0.2))
                                        )
                                    Text(localizedKey: "abc_feedback")
                                        .font(.system(size: UIConstants.TextSize.body, weight: .bold))
                                        .fontWeight(.medium)
                                        .foregroundColor(.Color.colorPrimary)
                                }
                            }
                        }
                        .padding(UIConstants.Padding.large)
                    }
                )
                
                VStack {
                    HStack {
                        if showLogo {
                            Image("ic_details_watermark")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.Color.colorPrimary)
                                .frame(width: UIConstants.actionBarSize)
                                .overlay(
                                    Button {
                                        showLogo = false
                                    } label: {
                                        Image("com_facebook_close")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width:UIConstants.sizeIconMedium, height: UIConstants.sizeIconMedium)
                                            .padding(UIConstants.Padding.extraLarge)
                                            .offset(x: 32, y: -12)
                                    }
                                )
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .padding(UIConstants.Padding.large)
            }
        }
    }
    
    @ViewBuilder
    func ResultTopbar() -> some View {
        HStack {
            Button {
                router.navigateBack()
            } label: {
                Image("ic_back")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(1, contentMode: .fit)
                    .bold()
                    .padding(UIConstants.Padding.medium)
                    .foregroundColor(.Color.colorPrimary)
                    .frame(height: UIConstants.actionBarSize)
            }
            
            Spacer()
            
            Text(localizedKey: "abc_art_work")
                .font(.system(size: UIConstants.TextSize.title,design: .default))
                .bold()
                .foregroundColor(.Color.colorPrimary)
            
            Spacer()
            
            Button {
                if let imageAfter = imageAfter {
                    if showLogo {
                        saveImageToPhotos(processImage(originalImage: imageAfter))
                    } else {
                        saveImageToPhotos(imageAfter)
                    }
                }
            } label: {
                Image("direct_download")
                    .resizable()
                    .renderingMode(.template)
                    .bold()
                    .foregroundColor(.Color.colorPrimary)
                    .padding(UIConstants.Padding.large)
                    .frame(width: UIConstants.actionBarSize, height: UIConstants.actionBarSize)
            }
        }
    }
    
    @ViewBuilder
    func SelectScaleViewResult() -> some View {
        VStack {
            Text("abc_select_ai_enchance_image")
                .foregroundColor(.white)
                .bold()
                .font(.system(size: UIConstants.TextSize.largeBody))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Button {
                    Task {
                        guard let imageAfter = imageAfter else {
                            return
                        }
                        await enhanceViewModel.fetchCreateImages(originalImage: imageAfter, faceImage: imageAfter)

                    }
                } label: {
                    HStack {
                        Text("2x")
                            .padding(UIConstants.Padding.medium)
                            .frame(maxWidth: .infinity)
                            .bold()
                            .foregroundColor(.white)
                            .background(Color(.Color.colorTextSelected))
                            .cornerRadius(UIConstants.CornerRadius.large)
                    }
                }
                
                Button {
                    Task {
                        guard let imageBefore = imageBefore else { return }
                        await enhanceViewModel.fetchCreateImages(originalImage: imageBefore, faceImage: imageBefore)
                    }
                } label: {
                    HStack {
                        Text("4x")
                            .padding(UIConstants.Padding.medium)
                            .frame(maxWidth: .infinity)
                            .bold()
                            .foregroundColor(.white)
                            .background(Color(.Color.colorTextSelected))
                            .cornerRadius(UIConstants.CornerRadius.large)
                    }
                }

            }
            .padding(UIConstants.Padding.medium)
            .background(Color(.Color.colorAccent))
            .cornerRadius(UIConstants.CornerRadius.large)
        }
    }
    
    func saveImageToPhotos(_ image: UIImage) {
        if let imageData = image.pngData() {
            let imageToSave = UIImage(data: imageData)
            UIImageWriteToSavedPhotosAlbum(imageToSave!, nil, nil, nil)
            
            showAlertDowload = true
        }
    }
    
    func loadImageFromURL(_ urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }

}

//#Preview {
//    ResultSwapFace()
//}
