//
//  HomeScreen.swift
//  ImageAI
//
//  Created by DoanhMac on 7/3/25.
//

import SwiftUI

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
            .environmentObject(Router())
    }
}

struct HomeScreen: View {
    @EnvironmentObject var router: Router
    @State private var tabs:[TabHome] = tabs_
    @StateObject private var viewModel : EaseViewModel = AppDIContainer.shared.makeEaseViewModel()
    @StateObject private var qwenViewModel : QwenViewModel = AppDIContainer.shared.makeQwenViewModel()
    @StateObject private var enhanceViewModel : EnhanceRestoreViewModel = AppDIContainer.shared.makeEnhanceRestoreViewModel()
    
    var body: some View {
        ZStack{
            BackgroundView()
            SupportView()
            if viewModel.state.isLoading {
                DialogLoadingScreen(progress: Float(viewModel.state.progress)) {
                    viewModel.cancelFetchTask()
                }
            }
            
            
            if qwenViewModel.state.isLoading {
                DialogLoadingQwenScreen {
                    qwenViewModel.cancelTask()
                }
            }
            if enhanceViewModel.state.isLoading {
                DialogLoadingScreen(progress: Float(enhanceViewModel.state.progress)) {
                    enhanceViewModel.cancelFetchTask()
                }
            }
        }

        
    }
    @ViewBuilder
    func SupportView() -> some View {
        VStack(
            alignment: .center
        ) {
            HomeTopBar(actionSetting: {
                router.navigateTo(.setting)
            }, actionHistory: {
                router.navigateTo(.history)
            }
            )
            Spacer()
            HomeContent()
        }
    }
    
    @ViewBuilder
    func HomeContent() -> some View {
        ZStack {
            VStack(spacing: 0) {
                TabView(selection: $router.currentTab) {
                    GenerateHeadshot(
                        enhanceViewModel: enhanceViewModel)
                        .tabItem {
                            Label( tabs[0].title, systemImage: tabs[0].icon)
                        }
                        .tag(TabType.generate)
                        .padding(.bottom, UIConstants.actionBarSize)
                        .navigationBarBackButtonHidden()
                    
                    ManageSwapFace(
                        enhanceViewModel: enhanceViewModel)
                        .tabItem {
                            Label( tabs[1].title, systemImage: tabs[1].icon)
                        }
                        .tag(TabType.swapface)
                        .padding(.bottom, UIConstants.actionBarSize)
                        .navigationBarBackButtonHidden()
                    
//                    TextToImageScreen(
//                        viewModel: viewModel,
//                        onGenerate: { easeCreateRequest in
//                            DispatchQueue.global(qos: .userInitiated).async {
//                                Task {
//                                    await viewModel.fetchCreateImages(
//                                        easeCreateRequest: easeCreateRequest
//                                        
//                                    )
//                                }
//                            }
//                        })
//                    .tabItem {
//                        Label(tabs[1].title, systemImage: tabs[1].icon)
//                    }
//                    .tag(TabType.textToImage)
//                    .padding(.bottom, UIConstants.actionBarSize)
//                    .navigationBarBackButtonHidden()
                    
                    ImageToTextScreen(
                        easeViewModel: viewModel,
                        qwenViewModel: qwenViewModel,
                        onGenerate: { easeCreateRequest in
                            DispatchQueue.global(qos: .userInitiated).async {
                                Task {
                                    await viewModel.fetchCreateImages(
                                        easeCreateRequest: easeCreateRequest
                                    )
                                }
                            }
                        }
                    )
                    .tabItem {
                        Label(tabs[2].title, systemImage: tabs[2].icon)
                    }
                    .tag(TabType.imageToText)
                    .padding(.bottom, UIConstants.actionBarSize)
                    .navigationBarBackButtonHidden()
                    
                    EnhanceScreen(
                        enhanceViewModel: enhanceViewModel) 
                        .tabItem {
                            Label( tabs[3].title, systemImage: tabs[3].icon)
                        }
                        .tag(TabType.enhance)
                        .padding(.bottom, UIConstants.actionBarSize)
                        .navigationBarBackButtonHidden()
                    
                    
                    RestoreScreen(
                        enhanceViewModel: enhanceViewModel)
                        .tabItem {
                            Label(tabs[4].title, systemImage: tabs[4].icon)
                        }
                        .tag(TabType.restore)
                        .padding(.bottom, UIConstants.actionBarSize)
                        .navigationBarBackButtonHidden()
                
                }
                
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            
            .accentColor(Color.blue)
            .ignoresSafeArea(.all)
            .overlay(alignment: .bottom) {
                
                TabsView()
                    .padding(.top, UIConstants.Padding.medium)
                    .background(Color(.Color.appBackground))
                    .clipShape(RoundedCorner(radius: UIConstants.CornerRadius.medium, corners: [.topLeft, .topRight]))
                
                
                
            }
            .background(Color.white)
            .clipShape(RoundedCorner(radius: UIConstants.CornerRadius.medium, corners: [.topLeft, .topRight]))
            
            
        }
    }
    
    @ViewBuilder
    func TabsView() -> some View {
        HStack(alignment: .center) {
            ForEach(tabs_, id: \.self) { tab in
                VStack {
                    Image(systemName: tab.icon)
                        .resizable()
                        .foregroundColor(router.currentTab == tab.type ? .blue : .gray)
                        .frame(width: UIConstants.sizeIconMedium, height: UIConstants.sizeIconMedium)
                    Text(localizedKey: tab.title)
                        .font(.system(size: UIConstants.TextSize.cardTitle, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .foregroundColor(router.currentTab == tab.type ? .blue : .gray)
                    
                }
                .frame(height: UIConstants.actionBarSize)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        router.currentTab = tab.type
                    }
                }
                
            }
        }
        
        
        
    }
    
}

//struct HomeContent: View {
//
//
//    var body: some View {
//
//
//
//
//
//    }
//
//
//
//
////    func updateTabFrame (_ tabViewWidth:CGFloat) {
////        let inputRange = tabs.indices.compactMap { indext ->CGFloat? in
////            return CGFloat(indext) * tabViewWidth
////        }
////        let outputRangeForWidth = tabs.compactMap { tab -> CGFloat? in
////            return tab.width
////        }
////        let outputRangeForPosition = tabs.compactMap { tab -> CGFloat? in
////            return tab.minX
////        }
////        let widthInterpolation = LinearInterpolation(inputRange:  inputRange, outputRange: outputRangeForWidth)
////        let positionInterpolation = LinearInterpolation(inputRange:  inputRange,  outputRange: outputRangeForPosition)
////
////        indicatorWidth = widthInterpolation.calculate(for: -contentOffset)
////        indicatorPosition = positionInterpolation.calculate(for: -contentOffset)
////    }
////
////    func indext(of tab:TabHome) -> Int {
////        return tabs.firstIndex(of: tab) ?? 0
////    }
//}


struct HomeTopBar: View {
    let actionSetting:() -> ()
    let actionHistory:() -> ()
    @State private var text: String = "DreamPic - AI Image Generator"
    @State private var clickEnable: Bool = false
    @State private var isHorizontal: Bool = true
    @State private var speed: Double = 2
    @State private var textSize: CGFloat = 24
    @State private var textColor: Color = .white
    @State private var textBackColor: Color = .clear
    @State private var needScrollTimes: Int = Int.max
    @State private var isScrollForever: Bool = true
    var body: some View {
        HStack(
            alignment: .center
        ) {
            Image(.icLogoHome)
                .resizable()
                .clipShape(Circle())
                .padding(UIConstants.Padding.small)
                .frame(width: UIConstants.actionBarSize, height: UIConstants.actionBarSize)
                .clipped(antialiased: true)
            Spacer()
            VStack(alignment: .center) {
                Spacer()
                
                ScrollTextView(
                    text: $text,
                    clickEnable: $clickEnable,
                    isHorizontal: $isHorizontal,
                    speed: $speed,
                    textSize: $textSize,
                    textColor: $textColor,
                    textBackColor: $textBackColor,
                    needScrollTimes: $needScrollTimes,
                    isScrollForever: $isScrollForever
            
                )
                Spacer()
              
            }.frame(height: 56, alignment: .center).multilineTextAlignment(.center)
          
            HStack {
                Button {
                    actionHistory()
                } label: {
                    
                    Image(.icHistory)
                        .resizable()
                        .renderingMode(.template)
                        .padding(UIConstants.Padding.large)
                    
                        .frame(width: UIConstants.actionBarSize, height: UIConstants.actionBarSize)
                        .background(Color(.Color.appBackground))
                        .foregroundColor(.Color.colorPrimary)
                    
                }

               
                Button {
                    actionSetting()
                } label: {
                    Image(.icSetting)
                        .resizable()
                        .renderingMode(.template)
                        .padding(UIConstants.Padding.large)
                        .frame(width: UIConstants.actionBarSize, height: UIConstants.actionBarSize)
                        .background(Color(.Color.appBackground))
                        .foregroundColor(.Color.colorPrimary)
                       
                }
            }.background(Color(.Color.appBackground))
            
            

           
            
        }
        .frame(height:UIConstants.actionBarSize)
        
    }
    
    
}

//            ForEach(tabs, id: \.self) { tab in
//                GeometryReader {
//                    let size = $0.size
//
//                    Group {
//                        if tab.title == TabType.textToImage.rawValue {
//                            TextToImageScreen()
//                        } else {
//                            ImageToTextScreen()
//                        }
//                    }
//                    .padding(.top, UIConstants.actionBarSize)
//                    .frame(width: size.width, height: size.height)
//                    .tag(tab)
//
//                }
//
//                .clipped()
//                .ignoresSafeArea()
//                .offsetX {rect in
//                    if currentTab.title == tab.title {
//                        contentOffset = rect.minX - (rect.width * CGFloat(indext(of: tab)))
//                    }
//                    updateTabFrame(rect.width)
//
//                }
//            }
//        }.tabViewStyle(.page(indexDisplayMode: .never))
//            .ignoresSafeArea(.all)
//            .overlay(alignment: .top) {
//                TabsView().background(.black)
//            }
//            .onAppear {
//                DispatchQueue.main.async {
//                    if let firstTab = tabs.first {
//                        currentTab = firstTab
//                    }
//                }

//#Preview {
//    HomeScreen()
//}
