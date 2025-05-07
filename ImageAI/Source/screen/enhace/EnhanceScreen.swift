//
//  EnhanceScreen.swift
//  ImageAI
//
//  Created by DoanhMac on 18/3/25.
//

import SwiftUI
import Kingfisher

struct EnhanceScreen: View {
    @EnvironmentObject var router: Router
    @ObservedObject var enhanceViewModel: EnhanceRestoreViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var upscaleButton = 2
    @State private var selectButton : Int = 0
    @State private var isShowAlert: Bool = false
    @State private var beforeImage: UIImage?
    @State private var afterImage: UIImage?
    @State private var currentPopup: PopupType? = nil
    let listSampleEnhanceData: [SampleEnhanceData] = SampleEnhanceData.getListSample()
    let enhanceModels: [EnhanceDataModel] = EnhanceDataModel.getListEnhanceData()
    @State private var category:String = "general"

    
    var body: some View {
        ZStack{
            BackgroundView()
            ScrollView {
                VStack(spacing: UIConstants.Padding.large) {
                    ButtonSelectImage(isShowPhoto: true) { uiImage in
                        beforeImage = uiImage
                    }
                  
                               
                    Text(localizedKey: "abc_enhance_sample")
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
                        if beforeImage != nil && afterImage != nil {
                            router.navigateTo(.result_enhance(beforeImage!, afterImage!, EnhanceCreateRequest(
                                mode: sampleEnhanceData.category ?? "General",
                                size: sampleEnhanceData.size ?? 2,
                                images: []
                            ), true, "", false))
                        }
                    }
                    SelectScaleView(upscaleButton: $upscaleButton)

                    Text(localizedKey: "abc_select_ai_enchance")
                        .foregroundColor(Color.white)
                        .bold()
                        .font(.system(size: UIConstants.TextSize.largeBody))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    
                    ForEach(enhanceModels.indices, id: \.self) { index in
                        Button(action: {
                            selectButton = index
                        }) {
                            HStack(spacing:UIConstants.Padding.medium) {
                                KFImage.url(URL(string: "\(enhanceModels[index].imageUrl)"))
                                    .placeholder({
                                        ShimmerEffect().cornerRadius(UIConstants.CornerRadius.large)
                                    })
                                    .loadDiskFileSynchronously()
                                    .cacheMemoryOnly()
                                    .resizable()
                                    .frame(width: UIConstants.sizeCardItem - UIConstants.Padding.large, height: UIConstants.sizeCardItem - UIConstants.Padding.large)
                                    .clipShape(RoundedCorner(radius: UIConstants.CornerRadius.medium, corners: [.topLeft, .topRight]))
                                
                                VStack(alignment: .leading,spacing:UIConstants.Padding.small) {
                                    
                                    Text(localizedKey:  enhanceModels[index].category ?? "")
                                        .bold()
                                        .font(.system(size:UIConstants.TextSize.largeBody))
                                        .foregroundColor(.white)
                                    
                                    Text(localizedKey: enhanceModels[index].prompt ?? "")
                                        .font(.system(size:UIConstants.TextSize.body))
                                        .lineLimit(3)
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .background(Color(.Color.colorAccent))
                            .cornerRadius(UIConstants.CornerRadius.large)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .overlay(
                                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.large)
                                    .strokeBorder(
                                        LinearGradient(
                                            gradient: Gradient(colors: selectButton == index ? [.Color.colorBlueStart, .Color.colorControlSelected] : [Color.clear, Color.clear]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        lineWidth: 3
                                    )
                            )
                        }
                    }
                    
                    GenerateButtonView (
                        isShowBackground: beforeImage != nil,
                        actionButton: {
                            guard let beforeImage = beforeImage else {
                                currentPopup = .image
                                return
                            }
                            let modeCategory: String
                            switch selectButton {
                            case 0:
                                modeCategory = "general"
                            case 1:
                                modeCategory = "anime"
                            case 2:
                                modeCategory = "old_photo"
                            default:
                                modeCategory = "general"
                            }
                            category = modeCategory

                            Task {
                                await enhanceViewModel.fetchCreateImages(
                                    enhanceCreateRequest: EnhanceCreateRequest(
                                        mode: modeCategory,
                                        size: upscaleButton,
                                        images: []
                                    ),
                                    uiImage: beforeImage
                                )
                            }
                        }
                    )
                }.padding(.horizontal, UIConstants.Padding.medium)
            }
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
            guard let origin = newValue?.first?.origin, let beforeImage = beforeImage else { return }
            
            Task {
                let currentDate = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let formattedDate = dateFormatter.string(from: currentDate)
                
                let imageUser = ImageUser.Builder()
                    .setId(-1)
                    .setPrompt(saveImageToDocuments(image: beforeImage) ?? "")
                    .setDate(formattedDate)
                    .setStyleId(upscaleButton)
                    .setImageUrl(origin)
                    .setSizeCanvas(category)
                    .setType(2)
                    .build()
                await userViewModel.addImage(imageUser)
            }
            

            let request = EnhanceCreateRequest(
                mode: category,
                size: upscaleButton,
                images: []
            )
            enhanceViewModel.cleanState()

            router.navigateTo(.result_enhance(beforeImage, nil, request, false, origin, false))
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
                                Text(localizedKey:  "abc_try")
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

struct SelectScaleView: View {
    @Binding var upscaleButton: Int
    var body: some View {
        VStack {
            Text(localizedKey: "abc_select_ai_enchance_image")
                .foregroundColor(.white)
                .bold()
                .font(.system(size: UIConstants.TextSize.largeBody))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack{
                Button(action: {
                    upscaleButton = 2
                }){
                    HStack{
                        Text("2x")
                            .padding(UIConstants.Padding.medium)
                            .frame(maxWidth: .infinity)
                            .bold()
                            .foregroundStyle(Color.white)
                            .background(upscaleButton != 2 ? Color.black.opacity(0.5) : Color(.Color.colorTextSelected))
                            .cornerRadius(UIConstants.CornerRadius.large)
                    }
                }
                
                Button(action: {
                    upscaleButton = 4
                }){
                    HStack{
                        Text("4x")
                            .padding(UIConstants.Padding.medium)
                            .frame(maxWidth: .infinity)
                            .bold()
                            .foregroundStyle(Color.white)
                            .background(upscaleButton != 4 ? Color.black.opacity(0.5) : Color(.Color.colorTextSelected))
                            .cornerRadius(UIConstants.CornerRadius.large)
                    }
                }
            }
            .padding(UIConstants.Padding.medium)
            .background(Color(.Color.colorAccent))
            .cornerRadius(UIConstants.CornerRadius.large)
        }
    }
}

struct ImageComparisonView: View {
    var beforeUIImage: UIImage?
    var afterUIImage: UIImage?
    var beforeImage: String? = nil
    var afterImage: String? = nil
    let beforeText: String
    let afterText: String
    let showText: Bool
    let showIcon: Bool
    let cornerRadius: CGFloat
    let isSelected: Bool
    let actionGetBefore: (UIImage) -> Void
    let actionGetAfter: (UIImage) -> Void
    @State private var timerStarted = false
    @State private var dividerPosition: CGFloat = 0.1
    @State private var autoSlide = true
    @State private var isDragging = false
    @GestureState private var dragOffset: CGSize = .zero

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if afterUIImage != nil {
                    Image(uiImage: afterUIImage!)
                        .resizable()
                        .scaledToFit()
                    
                }
                if beforeUIImage != nil {
                    Image(uiImage: beforeUIImage!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .mask(
                            HStack {
                                Rectangle()
                                    .frame(width: geometry.size.width * dividerPosition)
                                Spacer()
                            }
                        )
            
                }
                if afterImage != nil  {
                    KFImage.url(URL(string: afterImage!))
                        .placeholder({
                            ShimmerEffect().cornerRadius(UIConstants.CornerRadius.large)
                        })
                        .loadDiskFileSynchronously()
                        .cacheMemoryOnly()
                        .resizable()
                        .onSuccess({ imageResult in
                            actionGetAfter(imageResult.image)
                        })
                        .scaledToFit()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        
                }
                if beforeImage != nil  {
                    KFImage.url(URL(string: beforeImage!))
                        .placeholder({
                            ShimmerEffect().cornerRadius(UIConstants.CornerRadius.large)
                        })
                        .loadDiskFileSynchronously()
                        .cacheMemoryOnly()
                        .resizable()
                        .onSuccess({ imageResult in
                            actionGetBefore(imageResult.image)
                        })
                        .scaledToFit()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .mask(
                            HStack {
                                Rectangle()
                                    .frame(width: geometry.size.width * dividerPosition)
                                Spacer()
                            }
                        )
                }
                
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 2)
                    .position(x: geometry.size.width * dividerPosition, y: geometry.size.height / 2)
                
                if showText {
                    Text(localizedKey: beforeText)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                        .position(x: geometry.size.width * dividerPosition - 40, y: 30)
                    
                    Text(localizedKey: afterText)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                        .position(x: geometry.size.width * dividerPosition + 40, y: 30)
                }
                
                if showIcon {
                    Image(systemName: "arrow.left.and.right.circle")
                        .resizable()
                        .frame(width: 36, height: 36)
                        .foregroundColor(.white)
                        .position(x: geometry.size.width * dividerPosition, y: geometry.size.height / 2)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .gesture(
                isSelected ? nil : DragGesture()
                    .onChanged { value in
                        let newPosition = value.location.x / geometry.size.width
                        dividerPosition = min(max(newPosition, 0), 1)
                        isDragging = true
                    }
                    .onEnded { _ in
                        isDragging = false
                    }
                
            )
            .onAppear {
                startAutoSlide()
            }
        }
    }
    
    private func startAutoSlide() {
        guard !timerStarted else { return }
        timerStarted = true
        
        if autoSlide && !isDragging {
            withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                dividerPosition = dividerPosition >= 1.0 ? 0.0 : 1.0
            }
        }
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            guard autoSlide && !isDragging else { return }
            withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                dividerPosition = dividerPosition >= 1.0 ? 0.0 : 1.0
            }
        }
    }
}

#Preview {
    EnhanceScreen(enhanceViewModel: EnhanceRestoreViewModel(repository: AppDIContainer.shared.appRepository))
        .environmentObject(Router())
        .environmentObject(UserViewModel())
}

