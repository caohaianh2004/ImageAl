//
//  OnBoardingScreen.swift
//  ImageAI
//
//  Created by DoanhMac on 21/3/25.
//

import SwiftUI

struct OnBoardingScreen: View {
    @EnvironmentObject var router: Router
    @State private var selectedTab = 0
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(alignment: .center, spacing: UIConstants.Padding.large) {
                TabView(selection: $selectedTab){
                    VStack{
                        Spacer()
                        Image("intro_1")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .scaledToFit()
                        Spacer()
                        Text(localizedKey: "intro_1")
                            .foregroundStyle(Color.white)
                            .font(.system(size: UIConstants.TextSize.title))
                            .fontWeight(.regular)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Spacer()
                    }
                 
                    .tag(0)
                    
                    VStack{
                        Spacer()
                        Image("intro_2")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .scaledToFit()
                        Spacer()
                        Text(localizedKey: "intro_2")
                            .foregroundStyle(Color.white)
                            .font(.system(size: UIConstants.TextSize.title))
                            .fontWeight(.regular)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Spacer()
                    }
                    .tag(1)
                    
                    VStack{
                        Spacer()
                        Image("intro_3")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .scaledToFit()
                        Spacer()
                        
                        Text(localizedKey: "intro_3")
                            .foregroundStyle(Color.white)
                            .font(.system(size: UIConstants.TextSize.title))
                            .fontWeight(.regular)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Spacer()
                    }
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                HStack{
                    ForEach(0..<3) {index in
                        if  index == selectedTab{
                            Rectangle().fill(Color.blue)
                                .frame(width: 25,height: 10)
                                .cornerRadius(5)
                        }else{
                            Circle()
                                .foregroundColor(.gray)
                                .frame(width: 10,height: 10)
                        }
                    }
                    
                    
                    if selectedTab == 2 {
                        Spacer()
                        ZStack{
                            Button(action: {
                                UserDefaults.standard.set(true, forKey: KEY_FIRST_APP)
                                router.navigateTo(.home)
                                selectedTab = 0
                            }, label: {
                                Text(localizedKey: "get_start")
                                    .font(.title2)
                                    .foregroundStyle(Color.blue)
                                    .bold()
                            })
                        }
                        .padding()
                    }
                }
                .padding(.horizontal, UIConstants.Padding.small)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                if selectedTab < 2 {
                    Button(action: {
                        selectedTab += 1
                    }, label: {
                        Text(localizedKey: "next")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .font(.title2)
                            .cornerRadius(UIConstants.CornerRadius.large)
                            .padding()
                    })
                }
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
    }
}

let KEY_FIRST_APP = "firstApp"

#Preview {
    OnBoardingScreen()
}
