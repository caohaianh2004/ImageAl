//
//  LanguageScreen.swift
//  ImageAI
//
//  Created by DoanhMac on 20/3/25.
//

import SwiftUI

struct LanguageScreen: View {
    let isSetting: Bool
    @EnvironmentObject var languageViewModel: LanguageViewModel
    @EnvironmentObject var router: Router
    @State private var selectedIndex: Int? = nil
    @State private var isShowAlert: Bool = false
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(alignment: .leading, spacing: UIConstants.Padding.large) {
                HStack {
                    Text(localizedKey: "setting_language")
                        .lineLimit(1)
                        .font(.system(size: UIConstants.TextSize.title))
                        .foregroundColor(.white)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Button {
                        if !languageViewModel.state.selectedLanguageCode.isEmpty {
                            languageViewModel.doneSelectedLanguage(languageViewModel.state.selectedLanguageCode)
                            if isSetting {
                                router.popToRoot()
                                router.navigateTo(.on_boarding)
                            } else {
                                router.navigateTo(.on_boarding)
                            }
                          
                        } else {
                            isShowAlert.toggle()
                        }
                    } label: {
                        Image("tick")
                            .resizable()
                            .renderingMode(.template)
                            .bold()
                            .foregroundColor(.white)
                            .frame(width: UIConstants.sizeIconMedium,height: UIConstants.sizeIconMedium)
                    }

                }
                Spacer()
                
                if languageViewModel.state.isLoading {
                    ZStack {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .center)
                            .scaleEffect(x: 2, y: 2, anchor: .center)
                    }
                    
                } else {
                    ListLanguageView()
                }
                
              
                
                
            }.padding(.horizontal, UIConstants.Padding.medium)
        }.onAppear {
            languageViewModel.fetchLanguages()
        }.toast(isPresenting: $isShowAlert){
            AlertToast(displayMode: .banner(.slide), type: .regular, title: "Please select language!")
        }
    }
    @ViewBuilder
    func ListLanguageView() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: UIConstants.Padding.medium) {
                ForEach(languageViewModel.state.languages, id: \.self) { language in
                    ItemLang(isSelected: languageViewModel.state.selectedLanguageCode == language.langCode, languageName: language.langName , languageNative: language.langNameNative, isRTL: language.isRight, actionSelected: {
                        languageViewModel.setSelectedLanguage(language.langCode)
                        Logger.success("\(language.langCode)")
          
                    })
                }
            }
        }
    }
}

struct ItemLang: View {
    var isSelected: Bool
    var languageName: String
    var languageNative: String
    var isRTL: Bool
    let actionSelected: () -> Void

    var body: some View {
        Button(action: actionSelected) {
            HStack {
                if isRTL {
                    contentText(alignment: .trailing)
                    selectionIcon()
                    Spacer()
                } else {
                    selectionIcon()
                    contentText(alignment: .leading)
                    Spacer()
                }
            }
            .padding(UIConstants.Padding.medium)
            .background(Color(.Color.colorAccent))
            .clipShape(RoundedCorner(radius: UIConstants.Padding.extraLarge))
            .overlay(
                isSelected ? Capsule().stroke(.blue, lineWidth: 2) : nil
            )
        }
    }

    @ViewBuilder
    private func contentText(alignment: Alignment) -> some View {
        VStack(alignment: .leading) {
            Text(languageNative).fontWeight(.medium).foregroundStyle(.white)
            Text(languageName).foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: alignment)
    }

    private func selectionIcon() -> some View {
        Image(isSelected ? "ic_step_progress" : "ic_non_selected")
            .padding(.horizontal, UIConstants.Padding.large)
    }
}




//#Preview {
//    LanguageScreen(isSetting: true)
//        .environmentObject(LanguageViewModel())
//        .environmentObject(Router())
//}
