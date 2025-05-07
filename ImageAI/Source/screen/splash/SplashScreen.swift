//
//  SplashScreen.swift
//  ImageAI
//
//  Created by DoanhMac on 21/3/25.
//

import SwiftUI
import Lottie

struct SplashScreen: View {
    @EnvironmentObject var router: Router
    @State private var isTextVisible = false
   
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(alignment: .center, spacing: UIConstants.Padding.extraLarge) {
                Spacer()
                Image("ic_logo_home")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIConstants.sizeCardInstruction, height: UIConstants.sizeCardInstruction)
                    .clipShape(Circle())

            
                Text("DreamPic - AI Image Generator")
                    .font(.system(size: UIConstants.TextSize.title * 1.2, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .opacity(isTextVisible ? 1 : 0)
                Spacer()
                
                LottieView(animation: .named("anim_loading.json")).playbackMode(.playing(.toProgress(1, loopMode: .loop))).frame(height: 96)

            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding(.horizontal, UIConstants.Padding.large)
                .onAppear {
                    animateTextAndNavigate()
                }
        }
    }
    
    private func animateTextAndNavigate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeIn(duration: 1)) {
                isTextVisible = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let isFirstLaunch = UserDefaults.standard.bool(forKey: KEY_FIRST_APP)
                if !isFirstLaunch {
                    self.router.navigateTo(.select_language(false))
                } else {
                    self.router.navigateTo(.home)
                }
            }
        }
    }

}


#Preview {
    SplashScreen()
}
