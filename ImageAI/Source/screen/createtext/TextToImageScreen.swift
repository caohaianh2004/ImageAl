//
//  TextToImageScreen.swift
//  ImageAI
//
//  Created by DoanhMac on 7/3/25.
//

import SwiftUI

struct TextToImageScreen_Previews: PreviewProvider {
    static var previews: some View {
        TextToImageScreen(
            textPrompt: "",
            sizeCanvas: "1:1",
            viewModel: AppDIContainer.shared.makeEaseViewModel(),
            onGenerate: { _ in print("Generating image...") }
        )
        .environmentObject(Router())
        .environmentObject(UserViewModel())
    }
}

struct TextToImageScreen: View {
    @EnvironmentObject var router: Router
    @State var textPrompt: String = ""
    @State var sizeCanvas :String = ""
    @ObservedObject var viewModel: EaseViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var isHighlightEnabled: Bool = true
    let onGenerate: (EaseCreateRequest) -> Void
    @State private var currentPopup: PopupType? = nil
    @State private var lisCheckPrompt: [String] = []
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: UIConstants.Padding.large){
                        Color.clear.frame(height: 1).id("top")
                        EnterPrompt(
                            textPrompt : $textPrompt,
                            isHighlightEnabled: $isHighlightEnabled,
                            listCheckPrompt: $lisCheckPrompt,
                            actionSupport: {
                                router.navigateTo(.support)
                            },
                            isFocused: $isFocused
                        ).padding([.leading, .trailing], UIConstants.Padding.medium)
                        ChooseStyle(
                            styleId: $router.selectedStyleInText,
                            actionSeeAll: {
                                router.navigateTo(.see_all_style(1))
                            }
                        ).padding([.leading, .trailing], UIConstants.Padding.medium)
                        ChooseCanvas(sizeCanvas: $sizeCanvas).padding([.leading, .trailing], UIConstants.Padding.medium)
                        GenerateButtonView(
                            isShowBackground: !textPrompt.isEmpty,
                            actionButton: {
                                if textPrompt.isEmpty {
                                    currentPopup = .prompt
                                } else {
                                    if sizeCanvas.isEmpty {
                                        currentPopup = .ratio
                                    } else {
                                        viewModel.checkPrompt(txtPrompt: textPrompt) { result in
                                            if let result = result as? String {
                                                isHighlightEnabled = false
                                                lisCheckPrompt = []
                                                onGenerate(
                                                    EaseCreateRequest(
                                                        prompt: result,
                                                        size: sizeCanvas.replacingOccurrences(of: ":", with: "-"),
                                                        style: router.selectedStyleInText
                                                    )
                                                )
                                            } else if let result = result as? [String] {
                                                isHighlightEnabled = true
                                                lisCheckPrompt = result
                                                
                                            }
                                        }
                                        
                                        
                                    }
                                }
                            }
                        ).padding([.leading, .trailing], UIConstants.Padding.medium)
                        ChooseSample(actionSeeAll: { title, styleId in
                            router.selectInspiration = Inspiration(title: title, index: styleId)
                            router.navigateTo(.see_all_inspiration)
                        }).padding([.leading, .trailing], UIConstants.Padding.medium)
                        
                        Spacer()
                    }
                }
                .popup(isPresented: Binding(
                    get: { currentPopup?.isVisible ?? false },
                    set: { _ in currentPopup = nil }
                ))  {
                    if currentPopup?.isRatio == true {
                        ToastBottomCustom(
                            localizedKeyTitle: "choose_aspect_ratio"
                        ).padding(.horizontal, UIConstants.Padding.medium)
                    } else if currentPopup?.isPrompt == true {
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
                .onChange(of: router.selectInspiration, { oldValue, newValue in
                    if newValue !=  oldValue {
                        textPrompt = newValue.title
                        router.selectedStyleInText = newValue.index
                        withAnimation {
                            proxy.scrollTo("top", anchor: .top)
                        }
                    }
                })
                .onChange(of: viewModel.state.error, { oldValue, newValue in
                    if let error = newValue {
                        if error == "next_error" {
                            router.navigateTo(.result_image(
                                [],
                                EaseCreateRequest(
                                    prompt: textPrompt,
                                    size: sizeCanvas.replacingOccurrences(of: ":", with: "-"),
                                    style: router.selectedStyleInText
                                ),
                                false,
                                true
                            ))
                        } else if !error.isEmpty {
                            currentPopup = .valid
                        }
                    }
                })
                .onChange(of: viewModel.state.data) { oldValue, newValue in
                    if newValue != nil {
                        Task {
                            let currentDate = Date()
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let formattedDate = dateFormatter.string(from: currentDate)
                            
                            let imageUser = ImageUser.Builder()
                                .setId(-1)
                                .setPrompt(textPrompt)
                                .setDate(formattedDate)
                                .setStyleId(router.selectedStyleInText)
                                .setImageUrl(newValue?.first?.origin ?? "")
                                .setSizeCanvas(sizeCanvas.replacingOccurrences(of: ":", with: "-"))
                                .setType(1)
                                .build()
                            await userViewModel.addImage(imageUser)
                        }
                        
                        router.navigateTo(.result_image(
                            newValue!,
                            EaseCreateRequest(
                                prompt: textPrompt,
                                size: sizeCanvas.replacingOccurrences(of: ":", with: "-"),
                                style: router.selectedStyleInText
                            ),
                            false,
                            false
                        ))
                        viewModel.cleanState()
                    }
                }
                
            }
        }.onTapGesture {
            isFocused.toggle()
        }
    }
}

struct ChooseSample : View {
    let listDataInspirations : [StyleDataFromJson] = StyleJsonItem.getListStyleJson()
    let actionSeeAll : (String,Int) -> Void
    var body : some View {
        VStack(spacing:UIConstants.Padding.medium) {
            Text(localizedKey: "abc_inspirations").frame(maxWidth:.infinity, alignment: .leading).fontWeight(.bold).font(.system(size: UIConstants.TextSize.subtitle, design: .default)).foregroundColor(.Color.colorPrimary)
            LazyVStack {
                ForEach(listDataInspirations.indices, id: \.self) { index in
                    CardItemInspiration(
                        styleData:listDataInspirations[index]) { title, pos in
                            actionSeeAll(title, pos)
                        }
                }
            }
        }
    }
}

struct ChooseCanvas: View {
    @State private var canvases = CanvasData.getDataCanvas()
    @Binding var sizeCanvas :String
    var body: some View {
        VStack(spacing: UIConstants.Padding.large) {
            HStack(spacing:UIConstants.Padding.medium) {
                Text(localizedKey: "abc_choose_canvas")
                    .font(.system(size: UIConstants.TextSize.avatarStyle, weight: .bold, design: .default))
                    .foregroundColor(.Color.colorPrimary)
                Spacer()
            }
            ScrollView(.horizontal) {
                LazyHStack(alignment: .center){
                    ForEach(canvases.indices, id: \.self) { index in
                        CanvasItemCanvas(canvas: canvases[index], isSelected: sizeCanvas == canvases[index].title)
                            .onTapGesture {
                                sizeCanvas = canvases[index].title
                                
                            }
                    }
                }
                
            }
            
        }.fixedSize(horizontal: false, vertical: true)
    }
}

struct ChooseStyle: View {
    @Binding var styleId: Int
    let actionSeeAll : () -> Void
    let listStyle : [DataStyle] = StyleJsonItem.getListStyleSeeAll()
    var body: some View {
        VStack(spacing: UIConstants.Padding.large) {
            HStack(spacing:UIConstants.Padding.medium) {
                Text(localizedKey: "abc_choose_style").font(.system(size: UIConstants.TextSize.subtitle, weight: .medium, design: .default)).foregroundColor(.Color.colorPrimary)
                Spacer()
                Button {
                    actionSeeAll()
                } label: {
                    Text(localizedKey: "abc_see_all").font(.system(size: UIConstants.TextSize.subtitle, weight: .medium, design: .default)).foregroundColor(.Color.colorPrimary).underline(true)
                }
                
                
                Image("ic_arrow_right")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: UIConstants.sizeIconSmall, height:  UIConstants.sizeIconSmall)
                    .foregroundColor(.Color.colorPrimary)
                
            }
            
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(alignment: .top) {
                        ForEach(listStyle.indices, id: \.self) { index in
                            CardItemStyle(
                                item: listStyle[index],
                                isSelect: styleId == listStyle[index].styleId,
                                onSelectStyle: {
                                    styleId = listStyle[index].styleId
                                }
                            )
                            .id(index)
                        }
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .onChange(of: styleId) { _, newStyleId in
                    if let index = listStyle.firstIndex(where: { $0.styleId == newStyleId }) {
                        withAnimation {
                            scrollProxy.scrollTo(index, anchor: .center)
                        }
                    }
                }
            }

        }
    }
}

struct EnterPrompt: View {
    @State private var isRotated = false
    @Binding  var textPrompt: String
    @State var titlePrompt: String = ""
    let listSuggestPrompt: [String] = listInspired
    @Binding var isHighlightEnabled: Bool
    @Binding var listCheckPrompt: [String]
    let actionSupport: () -> ()
    @FocusState.Binding  var isFocused : Bool
    
    var body: some View {
        VStack {
            HStack {
                Text(titlePrompt).font(.system(size: UIConstants.TextSize.subtitle, weight: .medium, design: .default)).foregroundColor(.Color.colorPrimary)
                
                Button {
                    actionSupport()
                } label: {
                    Image("ic_help")
                        .resizable()
                        .renderingMode(.template)
                        .renderingMode(.template)
                        .frame(width: UIConstants.sizeIconSmall, height: UIConstants.sizeIconSmall)
                        .padding(UIConstants.Padding.small)
                        .foregroundColor(.Color.colorPrimary)
                }

                Spacer()
                
            }
            PromptEnterViewChild()
        }.onAppear {
            titlePrompt = LocalizationSystem.sharedInstance.localizedStringForKey(key: "abc_enter_prompt", comment: "")
        }
    }
    
    
    @ViewBuilder
    func PromptEnterViewChild() -> some View {
        VStack(alignment: .leading, spacing: UIConstants.Padding.medium) {
            ZStack {
                CustomTextEditor(
                    text: $textPrompt,
                    forbiddenWords: listCheckPrompt,
                    isHighlightEnabled: $isHighlightEnabled
                )
                .placeholder(when: textPrompt.isEmpty) {
                    Text(localizedKey: "abc_enter_prom")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                .fontWeight(.medium)
                .background(Color.clear)
                .focused($isFocused)
                .onReceive(textPrompt.publisher.last()) {
                    if ($0 as Character).asciiValue == 10 {
                        isFocused = false
                        textPrompt.removeLast()
                    }
                }
                
         
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isFocused = true
                    }
            }
            .padding(.bottom, 36)
           
            HStack(
                alignment: .center
            ) {
                Button {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isRotated.toggle()
                    }
                    textPrompt = listSuggestPrompt.randomElement() ?? textPrompt
                } label: {
                    HStack {
                        Image(systemName: "arrow.trianglehead.2.counterclockwise.rotate.90")
                            .renderingMode(.template)
                            .frame(width: UIConstants.sizeIconMedium - 6, height: UIConstants.sizeIconMedium - 6)
                            .foregroundColor(.Color.colorArange)
                            .rotation3DEffect(
                                .degrees(isRotated ? 360 : 0),
                                axis: (x: 0, y: 0, z: 1)
                            )
                        
                        Text(localizedKey: "get_inspired")
                            .font(.system(size: UIConstants.TextSize.body))
                            .foregroundColor(.Color.colorArange)
                            .padding(.horizontal, UIConstants.Padding.superSmall)
                            .padding(.vertical, UIConstants.Padding.superSmall)
                            .background(Color.clear.contentShape(Rectangle()))
                    }
                }
                
                
                Spacer()
                if !textPrompt.isEmpty {
                    Button {
                        textPrompt = ""
                    } label: {
                        Image("ic_close")
                            .resizable()
                            .renderingMode(.template)
                            .padding(2)
                            .frame(width: UIConstants.sizeIconSmall, height:  UIConstants.sizeIconSmall)
                            .foregroundColor(.Color.colorPrimary)
                            
                    }
                }
            }
        }
        
        .padding(UIConstants.Padding.medium)
        .background(
            RoundedRectangle(cornerRadius:UIConstants.CornerRadius.large)
                .fill(Color(.Color.colorAccent))
        )
        
        .overlay(
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
        .onChange(of: textPrompt) { oldValue, newValue in
            if !newValue.isEmpty {
                textPrompt = LocalizationSystem.sharedInstance.localizedStringForKey(key: textPrompt, comment: "")
            }
        }
        
    }
}



//#Preview {
//    TextToImageScreen(
//        viewModel: AppDIContainer.shared.makeEaseViewModel()) {_ in
//
//    }
//}
