//
//  RouterView.swift
//  ImageAI
//
//  Created by DoanhMac on 13/3/25.
//

import SwiftUI

struct RouterView<Content: View>: View {
    @StateObject var router: Router = Router()
    @StateObject var languageViewModel = LanguageViewModel()
    @StateObject var userViewModel: UserViewModel = UserViewModel()
    
    private let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: Router.Route.self) { route in
                    router.view(for: route)
                }
        }
        .environmentObject(router)
        .environment(\.layoutDirection, languageViewModel.isRTL ? .rightToLeft : .leftToRight)
        .environmentObject(languageViewModel)
        .environmentObject(userViewModel)
        
    }
}


class Router: ObservableObject {
    enum Route: Hashable {
        case splash
        case on_boarding
        case select_language(Bool)
        case home
        case result_image([EaseItem], EaseCreateRequest, Bool, Bool)
        case see_all_style(Int)
        case see_all_inspiration
        case result_enhance(UIImage, UIImage?,EnhanceCreateRequest,Bool, String, Bool) // BeforeUIIamge, AfterUIImage, Request, isSample, UrlStringResult, isHistory
        case result_restore(UIImage, UIImage?,RestoreCreateRequest, String, Bool)
        case result_headshot(UIImage, UIImage?,HeadShort, Bool, String, Bool)
        case result_swapface(UIImage, UIImage?,SwapFace, Bool, String, Bool)
        case result_multiface(UIImage, UIImage?, MultiSFace, Bool, String, Bool)
        case setting
        case history
        case support
        case choose_style(Int)
    }
    @Published var currentTab: TabType = .generate
    @Published var path: NavigationPath = NavigationPath()
    @Published var selectedStyleInText: Int = 1
    @Published var selectStyleInImage: Int = 1
    @Published var selectInspiration = Inspiration(title: "", index: 0)
    @Published var currentDate:String = ""
    @Published var createHeadShot : StyleHeadShot? = nil
    
    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .splash:
            SplashScreen().navigationBarBackButtonHidden()
        case .on_boarding:
            OnBoardingScreen().navigationBarBackButtonHidden()
        case .select_language(let isSetting):
            LanguageScreen(isSetting:isSetting).navigationBarBackButtonHidden()
        case .home:
            HomeScreen().navigationBarBackButtonHidden()
        case .result_image(let items, let request, let isHistory, let isError):
            ResultScreen(
                easeItems: items,
                easeRequest : request,
                isHistory: isHistory,
                isError : isError
            ).navigationBarBackButtonHidden()
        case .see_all_style(let type):
            SeeAllScreen(type: type).navigationBarBackButtonHidden()
        case .see_all_inspiration:
            SeeAllInspirations().navigationBarBackButtonHidden()
            
        case .result_enhance(let beforeImage, let afterImage, let enhanceRequest, let isSample, let urlString, let isHistory) :
            ResultEnhanceScreen(
                imageAfter: afterImage,
                imageBefore: beforeImage,
                isShowSample: isSample,
                enhanceCreateRequest: enhanceRequest,
                urlString: urlString,
                isHistory : isHistory
            ).navigationBarBackButtonHidden()
            
        case .result_restore(let beforeImage, let afterImage, let restoreRequest, let urlString, let isHistory) :
            ResultRestoreScreen(
                imageBefore: beforeImage,
                imageAfter: afterImage,
                restoreRequest: restoreRequest,
                urlString: urlString,
                isHistory: isHistory
            ).navigationBarBackButtonHidden()
            
        case .result_swapface(let beforeImage, let afterImage, let swapfaceRequest,let isSamPle ,let urlString, let isHistory) :
            ResultSwapFace(
               imageBefore: beforeImage,
               imageAfter: afterImage,
               isShowSample: isSamPle,
               restoreSwapFace: swapfaceRequest,
               urlString: urlString,
               isHistory: isHistory
            ).navigationBarBackButtonHidden()
            
        case . result_multiface(let beforeImage, let afterImage, let multifaceRequest, let isSamPle, let urlString, let isHistory) :
              ResultMultiFace(
                imageBefore: beforeImage,
                imageAfter: afterImage,
                isShowSample: isSamPle,
                restoreMultiface: multifaceRequest,
                urlString: urlString,
                isHistory: isHistory
              ).navigationBarBackButtonHidden()
            
        case .result_headshot(let beforeImage, let afterImage, let headshotRequest, let isSamPle, let urlString, let isHistory) :
            ResultGenerateHeadshot(
                imageBefore: beforeImage,
                imageAfter: afterImage,
                isShowSample: isSamPle,
                restoreHeadshot: headshotRequest,
                urlString: urlString,
                isHistory : isHistory
            ).navigationBarBackButtonHidden()
           
        case .setting :
            SettingScreen().navigationBarBackButtonHidden()
        case .history:
            HistoryScreen().navigationBarBackButtonHidden()
        case .support :
            SupportScreen().navigationBarBackButtonHidden()
        case .choose_style(let styleId):
            ChosseStyle(styleId: .constant(styleId)).navigationBarBackButtonHidden()
        }
    }
    
    func navigateTo(_ appRoute: Route) {
        path.append(appRoute)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}

struct Inspiration : Equatable {
    var title: String
    var index: Int
    
    init(title: String, index: Int) {
        self.title = title
        self.index = index
    }
}
