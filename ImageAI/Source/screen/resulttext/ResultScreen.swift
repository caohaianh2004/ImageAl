//
//  ResultScreen.swift
//  ImageAI
//
//  Created by DoanhMac on 11/3/25.
//

import SwiftUI
import Kingfisher
import Photos
import UIKit
import PopupView

struct ResultScreen: View {
    @EnvironmentObject var router: Router
    @StateObject private var viewModel : EaseViewModel = EaseViewModel(repository: AppDIContainer.shared.appRepository)
    @StateObject private var enhanceViewModel : EnhanceRestoreViewModel = AppDIContainer.shared.makeEnhanceRestoreViewModel()
    @EnvironmentObject var userViewModel: UserViewModel
    let  easeItems : [EaseItem]
    let  easeRequest : EaseCreateRequest
    let isHistory:Bool
    @State var isError:Bool
    let listStyle : [DataStyle] = StyleJsonItem.getListStyleSeeAll()
    let listCanvas : [CanvasData] = CanvasData.getDataCanvas()
    @State var imageUrl : String?
    @State var styleName:String?
    @State var sizeCanvas:CGFloat?
    @State var txtPromt:String?
    @State var imageUiImage:UIImage?
    @State var showLogo:Bool = false
    @State var showImageView:Bool = false
    @State var showDialogEdit:Bool = false
    @State var showAlertDowload:Bool = false
    @State var showDialogRe: Bool = false
    @State var isNotPrompt:Bool = false
    @State var sizeScale:Int = 2
    @State var isShowFeedBack:Bool = false
    @State private var currentPopup: PopupType? = nil
    @State private var lisCheckPrompt: [String] = []
    @State private var isHighlightEnabled: Bool = true
    
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: UIConstants.Padding.large) {
                ResultTopbar()
                ResultImage().padding(.horizontal,UIConstants.Padding.medium)
                ResultEditPrompt()
                SelectScaleViewResult().padding(.horizontal,UIConstants.Padding.medium)
                Spacer()
            }
            .onChange(of: viewModel.state.error, { oldValue, newValue in
                if let error = newValue {
                    if error == "next_error" {
                        router.navigateTo(.result_image(
                            [],
                            EaseCreateRequest(
                                prompt: txtPromt ?? "",
                                size: easeRequest.size,
                                style: easeRequest.style
                            ),
                            false,
                            true
                        ))
                    } else if !error.isEmpty {
                        currentPopup = .valid
                    }
                }
            })
            .popup(isPresented: Binding(
                get: { currentPopup?.isVisible ?? false },
                set: { _ in currentPopup = nil }
            ))  {
               if currentPopup?.isPrompt == true {
                    ToastBottomCustom(
                        localizedKeyTitle: "enter_prompt_guide"
                    ).padding(.horizontal, UIConstants.Padding.medium)
                } else if currentPopup?.isValid == true {
                    ToastBottomCustom(
                        localizedKeyTitle: "report_valid"
                    ).padding(.horizontal, UIConstants.Padding.medium)
                }
            } customize: {
                $0.type(.floater()) .position(.bottom).autohideIn(2)
            }
            .popup(isPresented: $isError) {
                DialogError {
                    isError = false
                    router.navigateBack()
                }
            } customize: {
                $0.type(.floater()).position(.bottom).closeOnTapOutside(false).closeOnTap(false) .dragToDismiss(false)
            }
            
            if viewModel.state.isLoading {
                DialogLoadingScreen(progress: Float(viewModel.state.progress)) {
                    viewModel.cancelFetchTask()
                }
            }
            
            //View Image Detail
            if showImageView {
                DialogImageDetail(
                    imageUIImage: showLogo ? processImage(originalImage: imageUiImage!) : imageUiImage!, sizeCanvas: sizeCanvas!) {
                        showImageView = false
                    }
            }
            
            //Re-Generate
            if showDialogRe {
                DialogGenerate(title: NSLocalizedString("regenaral_image", comment: ""),actionDismiss: {
                    showDialogRe = false
                }, actionConfirm: {
                    if let txtPromt = txtPromt {
                        if txtPromt.isEmpty {
                            currentPopup = .prompt
                            return
                        }
                        viewModel.checkPrompt(txtPrompt: txtPromt) { result in
                            if let result = result as? String {
                                isHighlightEnabled = false
                                lisCheckPrompt = []
                                Task {
                                    await viewModel.fetchCreateImages(easeCreateRequest: EaseCreateRequest(
                                        prompt: result, size: easeRequest.size, style: easeRequest.style
                                    ))
                                }
                            } else if let result = result as? [String] {
                                isHighlightEnabled = true
                                lisCheckPrompt = result
                                
                            }
                        }
                        
                        
                        
                    }
                    
                })
                
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
            
            if enhanceViewModel.state.isLoading {
                DialogLoadingScreen(progress: Float(enhanceViewModel.state.progress)) {
                    enhanceViewModel.cancelFetchTask()
                }
            }
            
            //Edit Prompt
            if showDialogEdit {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            showDialogEdit = false
                        }
                    }
                
                DialogEditPrompt(
                    textRequest: easeRequest.prompt,
                    actionDismiss: {
                    withAnimation {
                        showDialogEdit = false
                    }
                    }, actionGernerate: { prompt in
                        txtPromt = prompt
                        showDialogRe = true
                    })
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.spring())

            }
            
            
        }.onAppear {
            imageUrl = easeItems.first(where: { easeItem in
                !easeItem.nsfw
            })?.origin ?? easeItems.first?.origin
            Logger.error("imageUrl \(String(describing: imageUrl))")
            styleName = listStyle.first(where: { dataStyle in
                dataStyle.styleId == easeRequest.style
            })?.title
            sizeCanvas = listCanvas.first(where: { canvasData in
                canvasData.title == easeRequest.size.replacingOccurrences(of: "-", with: ":")
            })?.aspectRatio ?? 1
            
            if txtPromt == nil {
                txtPromt = easeRequest.prompt
            }
            
            viewModel.setCurrentDataList(easeItems)
            
        }.onChange(of: viewModel.state.data) { oldValue, newValue in
            guard let newValue = newValue else { return }
         
            
            if isHistory {
                Task {
                    let currentDate = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let formattedDate = dateFormatter.string(from: currentDate)
                    
                    let imageUser = ImageUser.Builder()
                        .setId(-1)
                        .setPrompt(txtPromt ?? "")
                        .setDate(formattedDate)
                        .setStyleId( easeRequest.style)
                        .setImageUrl(newValue.first?.origin ?? "")
                        .setSizeCanvas(easeRequest.size)
                        .setType(1)
                        .build()
                    await userViewModel.addImage(imageUser)
                }
             
                
                router.navigateTo(.result_image(
                    newValue,
                    EaseCreateRequest(
                        prompt: txtPromt ?? "",
                        size: easeRequest.size,
                        style: easeRequest.style
                    ),
                    false,
                    false
                ))
                viewModel.cleanState()
            } else {
                imageUrl = newValue.first(where: { !$0.nsfw })?.origin ?? newValue.first?.origin
            }
            
            
        }.toast(isPresenting: $showAlertDowload) {
            AlertToast(type: .complete(.green), title: Optional("abc_download"), subTitle: Optional("abc_download_image"))
        }.toast(isPresenting: $isNotPrompt){
            AlertToast(displayMode: .banner(.slide), type: .regular, title: "enter_prompt_guide")
        }.onChange(of: enhanceViewModel.state.data) { _, newValue in
            guard let origin = newValue?.first?.origin else { return }
            Task {
                let currentDate = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let formattedDate = dateFormatter.string(from: currentDate)
                
                let imageUser = ImageUser.Builder()
                    .setId(-1)
                    .setPrompt(saveImageToDocuments(image: imageUiImage!) ?? "")
                    .setDate(formattedDate)
                    .setStyleId(sizeScale)
                    .setImageUrl(origin)
                    .setSizeCanvas("general")
                    .setType(2)
                    .build()
                await userViewModel.addImage(imageUser)
            }
            let request = EnhanceCreateRequest(
                mode: "general",
                size: sizeScale,
                images: []
            )
            enhanceViewModel.cleanState()
            router.navigateTo(.result_enhance(imageUiImage!, nil, request, false, origin, false))
            
            
        }
        
    }
    
    @ViewBuilder
    func ResultEditPrompt() -> some View {
        VStack(spacing: UIConstants.Padding.medium) {
            HStack {
                Text(localizedKey: "abc_style")
                    .font(.system(size: UIConstants.TextSize.body, weight: .bold))
                    .fontWeight(.medium)
                    .foregroundColor(.gray.opacity(0.8))
                
                Text(localizedKey: styleName ?? "")
                    .font(.system(size: UIConstants.TextSize.body, weight: .bold))
                    .fontWeight(.bold)
                    .foregroundColor(.Color.colorPrimary)
            }.frame(maxWidth: .infinity, alignment: .leading)
            
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
            
            Button {
                showDialogEdit = true
            } label: {
                HStack {
                    CustomTextEditor(text: Binding<String>(
                        get: { txtPromt ?? "" },
                        set: { txtPromt = $0 }
                    ), forbiddenWords: lisCheckPrompt, isHighlightEnabled: $isHighlightEnabled, isEditText: false, maxLine: 1)
                        .font(.system(size: UIConstants.TextSize.body, weight: .bold))
                        .fontWeight(.medium)
                        .lineLimit(1)
                        .foregroundColor(.gray.opacity(0.8))
                      
                    Spacer()
                    
                    Image("ic_common_edit")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.Color.colorPrimary)
                        .frame(width: UIConstants.sizeIconMedium, height: UIConstants.sizeIconMedium)
                        .padding(UIConstants.Padding.medium)
                }
            }
            .padding(.horizontal, UIConstants.Padding.medium)
            .frame(maxWidth: .infinity)
            .background(content: {
                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.large)
                    .fill(Color(.Color.colorAccent))
            })
            
            
        }.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal,UIConstants.Padding.medium)
    }
    
    @ViewBuilder
    func ResultImage() -> some View {
        KFImage.url(URL(string: imageUrl ?? ""))
            .placeholder({
                if isError {
                    Image("image_error")
                        .resizable()
                        .aspectRatio(sizeCanvas, contentMode: .fit)
                }
                ShimmerEffect().cornerRadius(UIConstants.CornerRadius.large)
                
            })
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .resizable()
            .onSuccess({ result in
                showLogo = true
                imageUiImage = result.image
                
            })
            .aspectRatio(sizeCanvas, contentMode: .fit)
            .cornerRadius(UIConstants.CornerRadius.large)
            .onTapGesture {
                showImageView = true
            }
            .overlay(
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
                                .padding([.top], UIConstants.Padding.large)
                        }
                        Spacer()
                    }.padding(UIConstants.Padding.large)
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            Task {
                                if let currentIndex = viewModel.currentDataList.firstIndex(where: { $0.origin == imageUrl }) {
                                    if currentIndex == 0 && viewModel.currentDataList.count > 1 {
                                        imageUrl = viewModel.currentDataList[1].origin
                                    } else {
                                        await viewModel.fetchCreateImages(easeCreateRequest: easeRequest)
                                        if let firstItem = viewModel.currentDataList.first {
                                            imageUrl = firstItem.origin
                                        }
                                    }
                                } else {
                                    if let firstItem = viewModel.currentDataList.first {
                                        imageUrl = firstItem.origin
                                    }
                                }
                            
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
                                Text(localizedKey:  "abc_feedback")
                                    .font(.system(size: UIConstants.TextSize.body, weight: .bold))
                                    .fontWeight(.medium)
                                    .foregroundColor(.Color.colorPrimary)
                            }
                        }
                        
                        
                    }.padding(UIConstants.Padding.large)
                    
                }
            )
        
    }
    
    @ViewBuilder
    func SelectScaleViewResult() -> some View{
        VStack {
            Text(localizedKey: "abc_select_ai_enchance_image")
                .foregroundColor(.white)
                .bold()
                .font(.system(size: UIConstants.TextSize.largeBody))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack{
                Button(action: {
                    sizeScale = 2
                    Task {
                        guard let imageUiImage = imageUiImage else {
                            return
                        }
                        
                        await enhanceViewModel.fetchCreateImages(
                            enhanceCreateRequest: EnhanceCreateRequest(
                                mode: "general", size: 2, images: []
                            ),
                            uiImage: imageUiImage
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
                    sizeScale = 4
                    Task {
                        guard let imageUiImage = imageUiImage else {
                            return
                        }
                        
                        
                        await enhanceViewModel.fetchCreateImages(
                            enhanceCreateRequest: EnhanceCreateRequest(
                                mode: "general", size: 2, images: []
                            ),
                            uiImage: imageUiImage
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
                if let imageUiImage = imageUiImage {
                    if showLogo {
                        saveImageToPhotos(processImage(originalImage: imageUiImage))
                    } else {
                        saveImageToPhotos(imageUiImage)
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
    
    func saveImageToPhotos(_ image: UIImage) {
        if let imageData = image.pngData() {
            let imageToSave = UIImage(data: imageData)
            UIImageWriteToSavedPhotosAlbum(imageToSave!, nil, nil, nil)
            
            showAlertDowload = true
        }
        
     
    }
}

func processImage(originalImage: UIImage) -> UIImage {
    guard let logo = UIImage(named: "ic_details_watermark") else { return originalImage }

    let size = originalImage.size
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    originalImage.draw(in: CGRect(origin: .zero, size: size))

    let logoWidth = size.width * 0.2
    let logoHeight = logoWidth * (logo.size.height / logo.size.width)
    let logoSize = CGSize(width: logoWidth, height: logoHeight)
    let margin: CGFloat = 20  
    let logoOrigin = CGPoint(x: margin, y: margin)

    logo.draw(in: CGRect(origin: logoOrigin, size: logoSize))
    let finalImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return finalImage ?? originalImage
}

struct ResultScreen_Previews: PreviewProvider {
    static var previews: some View {
        ResultScreen(
            easeItems: [],
            easeRequest: EaseCreateRequest(prompt: "Nude", size: "1:1", style: 2),
            isHistory: false,
            isError: false
        )
        .environmentObject(Router())
        .environmentObject(UserViewModel())
    }
}

