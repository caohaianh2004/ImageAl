//
//  SettingScreen.swift
//  ImageAI
//
//  Created by DoanhMac on 20/3/25.
//

import SwiftUI
import StoreKit
struct SettingScreen: View {
    @EnvironmentObject var router: Router
    @State var isShowingShareSheet : Bool = false
    @Environment(\.requestReview) private var requestReview
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: UIConstants.Padding.large) {
                SettingTopbar()
//                Button(action: {
//                    
//                },label: {
//                    HStack(spacing: UIConstants.Padding.medium){
//                        Image(systemName: "crown.fill")
//                            .font(.title)
//                            .foregroundColor(.blue)
//                        Text(localizedKey: "menu_premium")
//                            .font(.title3)
//                            .bold()
//                            .foregroundStyle(Color.white)
//                    }
//                    .frame(maxWidth: .infinity,alignment: .leading)
//                    .padding()
//                    
//                    Image(systemName: "chevron.forward")
//                        .font(.title2)
//                        .foregroundColor(.white)
//                        .padding()
//                })
                
                HStack{
                    Button(action: {
                        router.navigateTo(.select_language(true))
                    },label: {
                        HStack(spacing: UIConstants.Padding.medium){
                            Image(systemName: "globe.central.south.asia.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                            Text(localizedKey: "setting_language")
                                .font(.title3)
                                .bold()
                                .foregroundStyle(Color.white)
                        }
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .padding()
                        
                        Image(systemName: "chevron.forward")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    })
                }
                HStack{
                    Button(action: {
                        EmailHelper.shared.send(subject: LocalizationSystem.sharedInstance.localizedStringForKey(key:"menu_help_title", comment: ""), body: LocalizationSystem.sharedInstance.localizedStringForKey(key:"menu_help_detail", comment: ""), to: ["phunggtheduy4896@gmail.com"])
                    },label: {
                        HStack(spacing: UIConstants.Padding.medium){
                            Image(systemName: "envelope.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                            Text(localizedKey: "setting_feed_back")
                                .font(.title3)
                                .bold()
                                .foregroundStyle(Color.white)
                        }
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .padding()
                        
                        Image(systemName: "chevron.forward")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    })
                }
                
                HStack{
                    Button(action: {
                        if let url = URL(string: "itms-apps://apps.apple.com/developer") {
                                        UIApplication.shared.open(url)
                                    }
                    },label: {
                        HStack(spacing: UIConstants.Padding.medium){
                            Image(systemName: "square.grid.3x3.middleright.filled")
                                .font(.title)
                                .foregroundColor(.blue)
                            Text(localizedKey: "setting_more_app")
                                .font(.title3)
                                .bold()
                                .foregroundStyle(Color.white)
                        }
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .padding()
                        
                        Image(systemName: "chevron.forward")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    })
                }
                
                HStack{
                    Button(action: {
                        isShowingShareSheet.toggle()
                    },label: {
                        HStack(spacing: UIConstants.Padding.medium){
                            Image(systemName: "square.and.arrow.up.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                            Text(localizedKey: "setting_share")
                                .font(.title3)
                                .bold()
                                .foregroundStyle(Color.white)
                        }
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .padding()
                        
                        Image(systemName: "chevron.forward")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    })
                }.sheet(isPresented: $isShowingShareSheet) {
                    ShareSheet(activityItems: ["English Grammar..."])
                }
                
                HStack{
                    Button(action: {
                        requestReview()
                    },label: {
                        HStack(spacing: UIConstants.Padding.medium) {
                            Image(systemName: "sparkles")
                                .font(.title)
                                .foregroundColor(.blue)
                            Text(localizedKey: "setting_rate_us")
                                .font(.title3)
                                .bold()
                                .foregroundStyle(Color.white)
                        }
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .padding()
                        
                        Image(systemName: "chevron.forward")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    })
                }
                Spacer()
                
               
                
                
            
            }
        }
    }
 
    @ViewBuilder
    func SettingTopbar() -> some View{
        HStack {
            Button {
                router.navigateBack()
            } label: {
                Image("ic_back")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(1, contentMode: .fit)
                    .bold()
                    .padding(UIConstants.Padding.medium)
                    .foregroundColor(.Color.colorPrimary)
                    .frame(height: UIConstants.actionBarSize )
                
            }
            
            Spacer()
            Text(localizedKey: "abc_setting")
                .font(.system(size: UIConstants.TextSize.title, design: .default))
                .fontWeight(.bold)
            
                .foregroundColor(.Color.colorPrimary)
            Spacer()
            
            Rectangle().frame(width: UIConstants.actionBarSize, height: UIConstants.actionBarSize).opacity(0)
        }
    }
}

#Preview {
    SettingScreen()
}
struct EmptyContentView: View {
    var body: some View {
        Color.clear
    }
}
