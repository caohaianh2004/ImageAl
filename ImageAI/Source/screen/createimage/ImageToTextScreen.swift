//
//  ImageToTextScreen.swift
//  ImageAI
//
//  Created by DoanhMac on 7/3/25.
//

import SwiftUI
import PopupView

struct ImageToTextScreen: View {
    @EnvironmentObject var router: Router
    @State var textPrompt: String = ""
    @State var sizeCanvas :String = ""

    @ObservedObject var easeViewModel: EaseViewModel
    @ObservedObject var qwenViewModel: QwenViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    let onGenerate: (EaseCreateRequest) -> Void
    @State private var selection: UIImage?
    @State private var isHighlightEnabled: Bool = true
    @State private var currentPopup: PopupType? = nil
    @State private var lisCheckPrompt: [String] = []
    @FocusState private var isFocused: Bool
    
    
    let croppingOptions = CroppedPhotosPickerOptions(doneButtonTitle: "Select",doneButtonColor: .orange)
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: UIConstants.Padding.large){
                        ButtonSelectImage(isShowPhoto: true) { uiImage in
                            if let uiImage = uiImage {
                                DispatchQueue.global(qos: .userInitiated).async {
                                    Task {
                                        
                                        await qwenViewModel.createQwenId(uiImage)
                                    }
                                }
                            }
                            
                        }.padding([.leading, .trailing], UIConstants.Padding.medium)
                        EnterPromptImageToImage(
                            textPrompt : $textPrompt,
                            isHighlightEnabled: $isHighlightEnabled,
                            listCheckPrompt: $lisCheckPrompt,
                            isFocused: $isFocused
                        ).padding([.leading, .trailing], UIConstants.Padding.medium)
                        ChooseStyle(
                            styleId: $router.selectStyleInImage,
                            actionSeeAll: {
                                router.navigateTo(.see_all_style(2))
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
                                        easeViewModel.checkPrompt(txtPrompt: textPrompt) { result in
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
                .onChange(of: qwenViewModel.state.promptResult, { oldValue, newValue in
                    let result = newValue ?? ""
                    if !result.isEmpty {
                        textPrompt = result
                    }
                })
                .onChange(of: easeViewModel.state.error, { oldValue, newValue in
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
                .onChange(of: easeViewModel.state.data) { oldValue, newValue in
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
                                style: router.selectStyleInImage
                            ),
                            false,
                            false
                        ))
                        easeViewModel.cleanState()
                    }
                }
                
            }
        }.onTapGesture {
            isFocused.toggle()
        }
    }
  
    
}

struct EnterPromptImageToImage: View {
    @State private var isRotated = false
    @Binding  var textPrompt: String
    @Binding var isHighlightEnabled: Bool
    @Binding var listCheckPrompt: [String]
    @FocusState.Binding  var isFocused : Bool
    
    let listSuggestPrompt: [String] = listInspired
    var body: some View {
        VStack {
            PromptEnterViewChildImage()
        }
    }
    
    
    @ViewBuilder
    func PromptEnterViewChildImage() -> some View {
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
        
    }
}

//#Preview {
//    ImageToTextScreen()
//}
