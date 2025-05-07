//
//  ResultEnhanceScreen.swift
//  ImageAI
//
//  Created by DoanhMac on 19/3/25.
//

import SwiftUI
import Foundation
import Kingfisher

struct ResultEnhanceScreen: View {
    @EnvironmentObject var router: Router
    @StateObject private var enhanceViewModel : EnhanceRestoreViewModel = AppDIContainer.shared.makeEnhanceRestoreViewModel()
    @EnvironmentObject var userViewModel: UserViewModel
    @State var imageAfter:UIImage? = nil
    @State var imageBefore:UIImage? = nil
    @State var showLogo:Bool = true
    @State var showAlertDowload:Bool = false
    @State var upscaleButton:Int = 2
    @State var isShowSample:Bool = false
    @State var category:String = ""
    var enhanceCreateRequest:EnhanceCreateRequest
    var urlString:String
    let isHistory:Bool
    @State var isShowFeedBack:Bool = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView {
                VStack(spacing: UIConstants.Padding.large) {
                    ResultTopbar()
                    SubResultView()
                    ResultImage()
                    SubImageResultView()
                    if !isHistory {
                        SelectScaleViewResult().padding(.horizontal,UIConstants.Padding.medium)
                    }
                    Spacer()
                }
            }
            
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
                        EmailHelper.shared.send(subject: LocalizationSystem.sharedInstance.localizedStringForKey(key:"menu_help_title", comment: ""),
                                                body: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key:"menu_help_detail", comment: "")) \(txtFeedBack)",
                                                to: ["phunggtheduy4896@gmail.com"])
                    }
                }
                
            }
            
        }.onAppear {
            upscaleButton = enhanceCreateRequest.size
            switch (enhanceCreateRequest.mode) {
            case "general" : category = "General"
            case "anime" : category = "Anime"
            case "old_photo" : category = "Old Photo"
            default:
                break
            }
            if !urlString.isEmpty && imageAfter == nil {
                loadImageFromURL(urlString) { uIImage in
                    imageAfter = uIImage
                }
            }
        }.toast(isPresenting: $showAlertDowload) {
            AlertToast(type: .complete(.green), title: Optional("abc_download"), subTitle: Optional("abc_download_image"))
        }.onChange(of: enhanceViewModel.state.data) { _, newValue in
            guard let origin = newValue?.first?.origin, let imageAfter = imageAfter else { return }
            
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
                        .setStyleId(upscaleButton)
                        .setImageUrl(origin)
                        .setSizeCanvas(category)
                        .setType(2)
                        .build()
                    await userViewModel.addImage(imageUser)
                }
            }
            
            let request = EnhanceCreateRequest(
                mode: enhanceCreateRequest.mode,
                size: enhanceCreateRequest.size,
                images: []
            )
            enhanceViewModel.cleanState()
            router.navigateTo(.result_enhance(imageAfter, nil, request, false, origin, false))
        }
    }
    
    
    @ViewBuilder
    func SubResultView() -> some View {
        VStack (spacing: UIConstants.Padding.small){
            HStack {
                Text(localizedKey: "size_image")
                    .bold()
                    .font(.system(size: UIConstants.TextSize.largeBody, weight: .bold, design: .default))
                    .foregroundColor(.white)
                if let imageBefore = imageBefore {
                    Text("\(imageBefore.size.width.description) x \(imageBefore.size.height.description)" )
                        .bold()
                        .font(.system(size: UIConstants.TextSize.largeBody, weight: .bold, design: .default))
                        .foregroundColor(Color(.Color.colorTextSelected))
                }
                Spacer()
            }.padding(.horizontal,UIConstants.Padding.medium)
            if let imageAfter = imageAfter, !isShowSample {
                HStack {
                    Text(localizedKey: "size_new")
                        .bold()
                        .font(.system(size: UIConstants.TextSize.largeBody, weight: .bold, design: .default))
                        .foregroundColor(.white)
                    
                    Text("\(imageAfter.size.width.description) x \(imageAfter.size.height.description)" )
                        .bold()
                        .font(.system(size: UIConstants.TextSize.largeBody, weight: .bold, design: .default))
                        .foregroundColor(Color(.Color.colorTextSelected))
                    
                    Spacer()
                }.padding(.horizontal,UIConstants.Padding.medium)
            }
        }
    }
    @ViewBuilder
    func SubImageResultView() -> some View {
        VStack(spacing: UIConstants.Padding.medium) {
            HStack {
                Text(localizedKey: "abc_type")
                    .bold()
                    .font(.system(size: UIConstants.TextSize.largeBody, weight: .bold, design: .default))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text(category)
                    .bold()
                    .font(.system(size: UIConstants.TextSize.largeBody, weight: .medium, design: .default))
                    .fontWeight(.medium)
                    .foregroundColor(Color(.Color.colorTextSelected))
                
                Spacer()
                
            }
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
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
            
        }.padding(.horizontal,UIConstants.Padding.medium)
    }
    
    @ViewBuilder
    func ResultImage() -> some View {
        if imageAfter == nil || imageBefore == nil {
            VStack(alignment: .center) {
                ShimmerEffect().cornerRadius(UIConstants.CornerRadius.large) .aspectRatio((imageBefore?.size.width ?? 1) / (imageBefore?.size.height ?? 1), contentMode: .fit)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.Color.colorAccent))
            .aspectRatio((imageBefore?.size.width ?? 1) / (imageBefore?.size.height ?? 1), contentMode: .fit)
            .cornerRadius(UIConstants.CornerRadius.large)
            .onTapGesture {}
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
                                    
                                    await enhanceViewModel.fetchCreateImages(
                                        enhanceCreateRequest: EnhanceCreateRequest(
                                            mode: enhanceCreateRequest.mode, size: enhanceCreateRequest.size, images: []
                                        ),
                                        uiImage: imageBefore
                                    )
                                    
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
                                    Text(localizedKey:  "abc_re_generate")
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
                                Text(localizedKey:  "abc_feedback")
                                    .font(.system(size: UIConstants.TextSize.body, weight: .bold))
                                    .fontWeight(.medium)
                                    .foregroundColor(.Color.colorPrimary)
                            }
                        }
                        
                        
                    }.padding(UIConstants.Padding.large)
                    
                }
            )
        } else {
            ZStack {
                
                
                ImageComparisonView(
                    beforeUIImage: imageBefore,
                    afterUIImage: imageAfter,
                    beforeText: "abc_before",
                    afterText: "abc_after",
                    showText: true,
                    showIcon: true,
                    cornerRadius: 12,
                    isSelected: false,
                    actionGetBefore: { UIImage in
                        
                    },
                    actionGetAfter: { UIImage in
                        
                    }
                )
                .aspectRatio((imageBefore?.size.width ?? 1) / (imageBefore?.size.height ?? 1), contentMode: .fit)
                .cornerRadius(UIConstants.CornerRadius.large)
                .onTapGesture {
                    
                }
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
                                        
                                        await enhanceViewModel.fetchCreateImages(
                                            enhanceCreateRequest: EnhanceCreateRequest(
                                                mode: enhanceCreateRequest.mode, size: enhanceCreateRequest.size, images: []
                                            ),
                                            uiImage: imageBefore
                                        )
                                        
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
                                        Text(localizedKey:  "abc_re_generate")
                                            .font(.system(size: UIConstants.TextSize.body, weight: .bold))
                                            .fontWeight(.medium)
                                            .foregroundColor(.Color.colorPrimary)
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            Button {
                                isShowFeedBack = true
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
                            
                            
                        }.padding(UIConstants.Padding.large)
                        
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
                                    Button(action: {
                                        showLogo = false
                                    }, label: {
                                        Image("com_facebook_close")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: UIConstants.sizeIconMedium, height: UIConstants.sizeIconMedium)
                                            .padding(UIConstants.Padding.extraLarge)
                                            .offset(x: 32 , y: -12)
                                        
                                    })
                                    
                                )
                            
                        }
                        Spacer()
                    }
                    Spacer()
                }.padding(UIConstants.Padding.large)
                
            }
            
        }
        
        
    }
    
    @ViewBuilder
    func ResultTopbar() -> some View{
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
                    .frame(height: UIConstants.actionBarSize )
                
            }
            
            
            Spacer()
            Text(localizedKey: "abc_art_work")
                .font(.system(size: UIConstants.TextSize.title, design: .default))
                .fontWeight(.bold)
            
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
                    .frame(width: UIConstants.actionBarSize, height: UIConstants.actionBarSize )
                
                
            }
        }
    }
    
    @ViewBuilder
    func SelectScaleViewResult() -> some View{
        VStack {
            Text("abc_select_ai_enchance_image")
                .foregroundColor(.white)
                .bold()
                .font(.system(size: UIConstants.TextSize.largeBody))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack{
                Button(action: {
                    Task {
                        guard let imageAfter = imageAfter else {
                            return
                        }
                        
                        await enhanceViewModel.fetchCreateImages(
                            enhanceCreateRequest: EnhanceCreateRequest(
                                mode: enhanceCreateRequest.mode, size: 2, images: []
                            ),
                            uiImage: imageAfter
                        )
                    }
                }){
                    HStack{
                        Text("2x")
                            .padding(UIConstants.Padding.medium)
                            .frame(maxWidth: .infinity)
                            .bold()
                            .foregroundStyle(Color.white)
                            .background( Color(.Color.colorTextSelected))
                            .cornerRadius(UIConstants.CornerRadius.large)
                    }
                }
                
                Button(action: {
                    Task {
                        guard let imageAfter = imageAfter else {
                            return
                        }
                        
                        await enhanceViewModel.fetchCreateImages(
                            enhanceCreateRequest: EnhanceCreateRequest(
                                mode: enhanceCreateRequest.mode, size: 4, images: []
                            ),
                            uiImage: imageAfter
                        )
                    }
                }){
                    HStack{
                        Text("4x")
                            .padding(UIConstants.Padding.medium)
                            .frame(maxWidth: .infinity)
                            .bold()
                            .foregroundStyle(Color.white)
                            .background( Color(.Color.colorTextSelected))
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
}

//#Preview {
//    ResultEnhanceScreen()
//}
