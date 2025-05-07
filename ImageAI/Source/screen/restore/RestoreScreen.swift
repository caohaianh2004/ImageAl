//
//  RestoreScreen.swift
//  ImageAI
//
//  Created by DoanhMac on 19/3/25.
//

import SwiftUI

struct RestoreScreen: View {
    @EnvironmentObject var router: Router
    @ObservedObject var enhanceViewModel: EnhanceRestoreViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    let listSampleEnhanceData: [SampleEnhanceData] = SampleEnhanceData.getListSampleRestore()
    @State private var isSelectEnhance = true
    @State private var isSelectColorizer = true
    @State private var imageUiSelect: UIImage? = nil
    @State private var isShowAlert: Bool = false
    @State private var beforeImage: UIImage?
    @State private var afterImage: UIImage?
    @State private var restoreType : String  = "restore_recolor"
    @State private var currentPopup: PopupType? = nil
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView{
                VStack(spacing: UIConstants.Padding.large) {
                    ButtonSelectImage(isShowPhoto: true) { uiImage in
                        beforeImage = uiImage
                    }
                    
                    Text(localizedKey:  "abc_enhance_sample")
                        .foregroundColor(.white)
                        .bold()
                        .font(.system(size: UIConstants.TextSize.largeBody))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    SampleEnhanceView { sampleEnhanceData, index in
                        loadImageFromURL(sampleEnhanceData.imageUrlFirst) { uiImage in
                            beforeImage = uiImage
                        }
                        loadImageFromURL(sampleEnhanceData.imageUrlSecond) { uIImage in
                            afterImage = uIImage
                        }

                        if beforeImage != nil && afterImage != nil{
                            router.navigateTo(.result_restore(beforeImage!, afterImage!, RestoreCreateRequest(
                                restore_type: sampleEnhanceData.category ?? "",
                                images: []
                            ), "", false))
                        }
                    }
                    
                    Text(localizedKey:  "abc_photo_restoration")
                        .foregroundColor(.white)
                        .bold()
                        .font(.system(size: UIConstants.TextSize.largeBody))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ResoterOptionsView()
                    
                    
                    GenerateButtonView(
                        isShowBackground: imageUiSelect != nil,
                        actionButton: {
                            if  beforeImage != nil {
                                if isSelectEnhance && isSelectColorizer {
                                    restoreType = "restore_recolor"
                                } else if isSelectEnhance && !isSelectColorizer {
                                    restoreType = "restore"
                                } else if !isSelectEnhance && isSelectColorizer {
                                    restoreType = "recolor"
                                }
                                Task {
                                    await enhanceViewModel.fetchCreateImages(restoreCreateRequest: RestoreCreateRequest(
                                        restore_type: restoreType, images: []
                                    ), uiImage:  beforeImage!)
                                }
                                
                            } else {
                                currentPopup  = .image
                            }
                        }
                    )

                
                   
                }.padding(.horizontal, UIConstants.Padding.medium)
            }
            .popup(isPresented: Binding(
                get: { currentPopup?.isVisible ?? false },
                set: { _ in currentPopup = nil }
            ))  {
                if currentPopup?.isImage == true {
                    ToastBottomCustom(
                        localizedKeyTitle: "noti_select_image"
                    ).padding(.horizontal, UIConstants.Padding.medium)
                }
            } customize: {
                $0.type(.floater()) .position(.bottom).autohideIn(2)
            }
            
            .onChange(of: enhanceViewModel.state.data) { _, newValue in
                guard let origin = newValue?.first?.origin else { return }
                
                Task {
                    let currentDate = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let formattedDate = dateFormatter.string(from: currentDate)
                    
                    let imageUser = ImageUser.Builder()
                        .setId(-1)
                        .setPrompt(saveImageToDocuments(image: beforeImage!) ?? "")
                        .setDate(formattedDate)
                        .setImageUrl(origin)
                        .setSizeCanvas(restoreType)
                        .setType(3)
                        .build()
                    await userViewModel.addImage(imageUser)
                }

                let request = RestoreCreateRequest(
                    restore_type: restoreType,
                    images: []
                )
                enhanceViewModel.cleanState()
                router.navigateTo(.result_restore(beforeImage!, nil, request,origin, false))
            }

        }
    }
    
    @ViewBuilder
    func ResoterOptionsView() -> some View {
        VStack(spacing: UIConstants.Padding.large) {
            
            HStack(spacing:UIConstants.Padding.medium) {
                VStack(alignment: .leading,spacing:UIConstants.Padding.small) {
                    
                    Text(localizedKey: "enhance")
                        .bold()
                        .font(.system(size:UIConstants.TextSize.largeBody))
                        .foregroundColor(.white)
                    
                    Text(localizedKey: "abc_photo_sub")
                        .font(.system(size:UIConstants.TextSize.body))
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Button {
                    isSelectEnhance.toggle()
                } label: {
                    Image(isSelectEnhance ? "ratio_selected" : "ratio_unselected")
                        .resizable()
                        .padding(UIConstants.Padding.small)
                        .frame(width: UIConstants.actionBarSize, height: UIConstants.actionBarSize - UIConstants.Padding.medium)
                }
                
                
            }
            .padding(.vertical, UIConstants.Padding.large * 1.5)
            .padding(.horizontal, UIConstants.Padding.large)
            .background(Color(.Color.colorAccent))
            .cornerRadius(UIConstants.CornerRadius.large)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            
            HStack(spacing:UIConstants.Padding.medium) {
                VStack(alignment: .leading,spacing:UIConstants.Padding.small) {
                    
                    Text(localizedKey: "abc_colorizer")
                        .bold()
                        .font(.system(size:UIConstants.TextSize.largeBody))
                        .foregroundColor(.white)
                    
                    Text(localizedKey: "abc_colorizer_sub")
                        .font(.system(size:UIConstants.TextSize.body))
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Button {
                    isSelectColorizer.toggle()
                } label: {
                    Image(isSelectColorizer ? "ratio_selected" : "ratio_unselected")
                        .resizable()
                        .padding(UIConstants.Padding.small)
                        .frame(width: UIConstants.actionBarSize, height: UIConstants.actionBarSize - UIConstants.Padding.medium)
                }

              
                
                
            }
            .padding(.vertical, UIConstants.Padding.large * 2)
            .padding(.horizontal, UIConstants.Padding.large)
            .background(Color(.Color.colorAccent))
            .cornerRadius(UIConstants.CornerRadius.large)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
        }
    }
    
    @ViewBuilder
    func SampleEnhanceView(onSelectSample: @escaping (SampleEnhanceData,Int) -> ()) -> some View {
        HStack {
            ForEach(listSampleEnhanceData.indices, id: \.self) { item in
                Button(action: {
                    onSelectSample(listSampleEnhanceData[item], item)
                }) {
                    ImageComparisonView(
                        beforeImage: listSampleEnhanceData[item].imageUrlFirst,
                        afterImage: listSampleEnhanceData[item].imageUrlSecond,
                        beforeText: "abc_before",
                        afterText: "abc_after",
                        showText: false,
                        showIcon: false,
                        cornerRadius: 12,
                        isSelected: true,
                        actionGetBefore: { beforeImageResult in},
                        actionGetAfter: { afterImageResult in}
                    )

                    
                    .cornerRadius(UIConstants.CornerRadius.large)
                    .overlay(
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text(localizedKey: "abc_try")
                                    .font(.system(size: UIConstants.Padding.medium, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: UIConstants.sizeCardTry, height: UIConstants.sizeCardTry)
                                    .background(Circle().fill(Color(.Color.colorTextSelected)))
                            }
                            .padding(UIConstants.Padding.superSmall)
                            
                            
                        }
                    )
                }
            }.aspectRatio(1,contentMode: .fit)
        }
        
    }

}


