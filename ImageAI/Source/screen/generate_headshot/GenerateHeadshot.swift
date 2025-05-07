import SwiftUI
import Kingfisher

struct GenerateHeadshot: View {
    @EnvironmentObject var router: Router
    @StateObject var headShot = HeadShots(Dataheadshot: dsheadshot)
    @State  var styleId: Int = 0
    @State private var sizeCanvas: String = "1:1"
    @State private var selecterItems = "👥All"
    @State private var selectedStyle: String = ""
    @State private var isShowAlert: Bool = false
    @State private var beforeImage: UIImage?
    @State private var afterImage: UIImage?
    @State private var currentPopup: PopupType? = nil
    @ObservedObject var enhanceViewModel: EnhanceRestoreViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    let listSampleEnhanceData: [SampleEnhanceData] = SampleEnhanceData.getListSample()
    let items = ["👥All", "♂️Man", "♀️Woman"]
    var filtereHeadShots: [StyleHeadShot] {
        switch selecterItems {
        case "♂️Man":
            return dsheadshot.filter { $0.gender == "Man" }
        case "♀️Woman":
            return dsheadshot.filter { $0.gender == "Woman" }
        default:
            return dsheadshot
        }
    }
    var filteredStyles: [String] {
        Array(Set(filtereHeadShots.map { $0.style })).sorted()
    }
    @State private var scrollProxyStyle: ScrollViewProxy?
    @State private var scrollProxyAvatar : ScrollViewProxy?
    
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView {
                VStack(spacing: 16) {
                    ButtonSelectImage(isShowPhoto: true) { uiimage in
                        beforeImage = uiimage
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
                    
                    ChooseCanvas(sizeCanvas: $sizeCanvas)
                    
                    HStack {
                        NavigationLink(destination:
                                        ChosseStyle(styleId: $styleId)
                            .onDisappear {
                                if let selected = dsheadshot.first(where: { $0.id == styleId }) {
                                    selectedStyle = selected.style
                                }
                            }
                        ) {
                            Text(localizedKey: "abc_headshot")
                                .font(.system(size: UIConstants.TextSize.avatarStyle, weight: .bold, design: .default))
                                .foregroundColor(.Color.colorPrimary)
                        }
                        
                        Spacer()
                        
                        ZStack {
                            Menu {
                                ForEach(items, id: \.self) { genden in
                                    Button {
                                        selecterItems = genden
                                    } label: {
                                        Text(genden)
                                    }
                                }
                            } label: {
                                Text(selecterItems)
                                    .foregroundColor(.white)
                                    .frame(width: 90, height: 40)
                                    .font(.system(size: UIConstants.TextSize.sizeall))
                                    .background(
                                        RoundedRectangle(cornerRadius: UIConstants.CornerRadius.large)
                                            .strokeBorder(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [.Color.colorBlueStart, .Color.colorControlSelected]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                ),
                                                lineWidth: 2
                                            )
                                    )
                            }
                            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.large)
                                .strokeBorder(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.Color.colorBlueStart, .Color.colorControlSelected]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    lineWidth: 2
                                )
                                .frame(width: 90, height: 40)
                        }
                    }
                    
                    HStack {
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(filteredStyles, id: \.self) { style in
                                        Button(action: {
                                            withAnimation {
                                                selectedStyle = style
                                                proxy.scrollTo(style, anchor: .center)
                                            }
                                        }) {
                                            Text(style.uppercased())
                                                .id(style)
                                                .font(.system(size: UIConstants.TextSize.sizeall))
                                                .padding(.vertical, 8)
                                                .padding(.horizontal, 12)
                                                .font(.system(size: 15))
                                                .bold()
                                                .foregroundColor(selectedStyle == style ? Color.white : Color.gray)
                                                .cornerRadius(UIConstants.CornerRadius.large)
                                                .overlay(
                                                    Rectangle()
                                                        .fill(Color.white)
                                                        .frame(height: selectedStyle == style ? 2 : 0)
                                                        .offset(y: 1),
                                                    alignment: .bottom
                                                )
                                        }
                                    }
                                }
                                .padding(.vertical, 8)
                                .onAppear {
                                    scrollProxyStyle = proxy
                                }
                            }
                        }
                        
                        HStack {
                            Button {
                                router.navigateTo(.choose_style(styleId))
                            } label: {
                                Text(localizedKey: "abc_see_all")
                                    .font(.system(size: UIConstants.TextSize.sizeall))
                                    .foregroundColor(.Color.colorPrimary)
                            }
                            Image("ic_arrow_right")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: UIConstants.sizeIconSmall, height: UIConstants.sizeIconSmall)
                                .foregroundColor(.Color.colorPrimary)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.large)
                                .strokeBorder(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.Color.colorBlueStart, .Color.colorControlSelected]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    lineWidth: 2
                                )
                                .frame(width: 90, height: 40)
                        )
                    }
                    
                    if !selectedStyle.isEmpty {
                        HStack {
                            ScrollViewReader { proxy in
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(filtereHeadShots.filter { $0.style == selectedStyle }) { item in
                                            Button(action: {
                                                styleId = item.id
                                            }) {
                                                ZStack {
                                                    KFImage.url(URL(string: item.avatar))
                                                        .placeholder {
                                                            ShimmerEffect().cornerRadius(UIConstants.CornerRadius.large)
                                                        }
                                                        .loadDiskFileSynchronously()
                                                        .cacheMemoryOnly()
                                                        .resizable()
                                                        .frame(width: 100, height: 120)
                                                        .cornerRadius(UIConstants.CornerRadius.large)
                                                    
                                                    if styleId == item.id {
                                                        RoundedRectangle(cornerRadius: UIConstants.CornerRadius.large)
                                                            .strokeBorder(
                                                                LinearGradient(
                                                                    gradient: Gradient(colors: [.Color.colorBlueStart, .Color.colorControlSelected]),
                                                                    startPoint: .leading,
                                                                    endPoint: .trailing
                                                                ),
                                                                lineWidth: 3
                                                            )
                                                            .frame(width: 100, height: 120)
                                                    }
                                                }
                                                .overlay(
                                                    VStack {
                                                        Spacer()
                                                        HStack {
                                                            Spacer()
                                                            Text(localizedKey: "abc_try")
                                                                .font(.system(size: UIConstants.Padding.medium, weight: .bold))
                                                                .foregroundColor(.white)
                                                                .frame(width: UIConstants.sizeCardTry,
                                                                       height: UIConstants.sizeCardTry)
                                                                .background(Circle()
                                                                    .fill(Color(.Color.colorTextSelected)))
                                                        }
                                                        .padding(UIConstants.Padding.superSmall)
                                                    }
                                                )
                                            }
                                        }
                                    }
                                }
                                .onAppear {
                                    scrollProxyAvatar = proxy
                                }
                            }
                        }
                    }
                    
                    GenerateButtonView(
                        isShowBackground: beforeImage != nil,
                        actionButton: {
                            guard let beforeImage = beforeImage else {
                                currentPopup = .image
                                return
                            }
                            Task {
                                await enhanceViewModel.fetchCreateImages(
                                    headshotCreateRequest: HeadShort(
                                        size: sizeCanvas.replacingOccurrences(of: ":", with: "-"),
                                        style: styleId,
                                        images: []
                                    ),
                                    uiImage: beforeImage
                                )
                            }
                        }
                    )
                    .cornerRadius(30)
                }
                .padding(.horizontal, UIConstants.Padding.medium)
            }
        }
        .popup(isPresented: Binding(
            get: { currentPopup?.isVisible ?? false },
            set: { _ in currentPopup = nil }
        )) {
            if currentPopup?.isImage == true {
                ToastBottomCustom(
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
                    .setSizeCanvas(sizeCanvas)
                    .setType(5)
                    .build()
                await userViewModel.addImage(imageUser)
            }
            let request = HeadShort(
                size: sizeCanvas.replacingOccurrences(of: ":", with: "-"),
                style: styleId,
                images: []
            )
            enhanceViewModel.cleanState()
            router.navigateTo(.result_headshot(beforeImage, nil, request, false, origin, false))
        }
        .onChange(of: styleId) { _, newId in
            if let selected = dsheadshot.first(where: { $0.id == newId }) {
                selectedStyle = selected.style
            }
            DispatchQueue.main.async {
                withAnimation {
                    scrollProxyAvatar?.scrollTo(newId, anchor: .center)
                }
            }
        }
        .onChange(of: router.createHeadShot) { _, newValue in
            Logger.success("\(newValue)")
            if let check = newValue {
                styleId = check.id
            }
        }
        .onAppear {
            if let selected = dsheadshot.first(where: { $0.id == styleId }) {
                selectedStyle = selected.style
            } else if selectedStyle.isEmpty {
                selectedStyle = filteredStyles.first ?? ""
            }
        }
        .onChange(of: selectedStyle) { _, newValue in
            DispatchQueue.main.async {
                withAnimation {
                    scrollProxyStyle?.scrollTo(newValue, anchor: .center)
                }
            }
        }
    }
    
    @ViewBuilder
    func SampleEnhanceView(onSelectSample: @escaping (SampleEnhanceData, Int) -> ()) -> some View {
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
                        actionGetBefore: { beforeImageResult in },
                        actionGetAfter: { afterImageResult in }
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
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }
}

//#Preview {
//GenerateHeadshot()
//}
