//
//  DialogLoadingScreen.swift
//  ImageAI
//
//  Created by DoanhMac on 11/3/25.
//

import SwiftUI
import Lottie

struct DialogLoadingScreen: View {
    let progress: Float
    let actionBack: () -> ()
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                HStack {
                    Button {
                        actionBack()
                    } label: {
                        Image("ic_close")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.regular)
                            .padding(UIConstants.Padding.large)
                            .background(
                                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.extraLarge).fill(Color.gray.opacity(0.5))
                            )
                    
                    }
                    .padding(UIConstants.Padding.superSmall)
                    .frame(width: UIConstants.actionBarSize, height: UIConstants.actionBarSize)
                }
                .padding(UIConstants.Padding.medium)
                .frame(maxWidth: .infinity, alignment: .trailing)
                
             
                
                VStack(
                    spacing: UIConstants.Padding.large
                ) {
                    LottieView(animation: .named("loading.json")).playbackMode(.playing(.toProgress(1, loopMode: .loop))).frame(height: UIConstants.heigthLottieLoading)
                        
                    
                    Text(localizedKey: "abc_in_queue")
                        .font(.system(size: UIConstants.TextSize.subtitle))
                        .fontWeight(.medium)
                        .foregroundColor(.Color.colorPrimary)
                        .multilineTextAlignment(.center)
                    
                    ProgressView(value: progress, total: 100)
                        .progressViewStyle(LinearProgressViewStyle())
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                        .frame(height: UIConstants.Padding.large)
                        
                    
                }
                
                .padding(UIConstants.Padding.large)
                
                Spacer()
                
                
            }
        }
    }
    
}


struct DialogLoadingQwenScreen: View {
    let actionBack: () -> ()
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                HStack {
                    Button {
                        actionBack()
                    } label: {
                        Image("ic_close")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.regular)
                            .padding(UIConstants.Padding.large)
                            .background(
                                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.extraLarge).fill(Color.gray.opacity(0.5))
                            )
                    
                    }
                    .padding(UIConstants.Padding.superSmall)
                    .frame(width: UIConstants.actionBarSize, height: UIConstants.actionBarSize)
                }
                .padding(UIConstants.Padding.medium)
                .frame(maxWidth: .infinity, alignment: .trailing)
                
             
                LottieView(animation: .named("loading.json")).playbackMode(.playing(.toProgress(1, loopMode: .loop))).frame(height: UIConstants.heigthLottieLoading)
                VStack(
                    spacing: UIConstants.Padding.large
                ) {
                   
                    Text("abc_in_queue")
                        .font(.system(size: UIConstants.TextSize.subtitle))
                        .fontWeight(.medium)
                        .foregroundColor(.Color.colorPrimary)
                        .multilineTextAlignment(.center)

                }
                .padding(UIConstants.Padding.large)
                
                LottieView(animation: .named("loading_qwen.json")).playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                    .frame(height: UIConstants.Padding.large)  .scaleEffect(x: 1.4, y: 1, anchor: .center)
                Spacer()
                
                
            }
        }
        
        
    }
    
}

struct DialogLoadingQwenScreen_Preview: PreviewProvider {
    static var previews: some View {
        DialogLoadingQwenScreen() {
                
            }
    }
}



