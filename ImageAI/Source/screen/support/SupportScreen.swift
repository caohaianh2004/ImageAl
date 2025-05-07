//
//  SupportScreen.swift
//  ImageAI
//
//  Created by DoanhMac on 25/3/25.
//

import SwiftUI

struct SupportScreen: View {
    @EnvironmentObject var router: Router
    var body: some View {
       
            ZStack{
                BackgroundView()
                ScrollView{
                    VStack(spacing: UIConstants.Padding.large){
                        
                        HStack(alignment: .center) {
                            Spacer()
                            Spacer()
                            Text(localizedKey: "watch_a_quick_tutorial")
                                .font(.system(size: UIConstants.TextSize.title))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                            
                            Button {
                                router.navigateBack()
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
                        }.frame(width: .infinity, height: .infinity, alignment: .center)
                        
                        
                        
                        Text(localizedKey:  "to_master_the_skill")
                            .font(.system(size: UIConstants.TextSize.subtitle))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, UIConstants.Padding.extraLarge)
                        
                        
                        Text(localizedKey: "bad_prompt")
                            .font(.system(size: UIConstants.TextSize.subtitle))
                            .foregroundColor(.white)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        ZStack {
                            HStack(spacing:UIConstants.Padding.medium) {
                                Image("img_tutorial_woman")
                                    .resizable()
                                    .frame(width: UIConstants.sizeCardItem - UIConstants.Padding.large, height: UIConstants.sizeCardItem - UIConstants.Padding.large)
                                    .clipShape(RoundedCorner(radius: UIConstants.CornerRadius.medium, corners: [.topLeft, .topRight]))
                                
                                VStack(alignment: .leading,spacing:UIConstants.Padding.small) {
                                    
                                    Text(localizedKey: "enter_your_prompt")
                                        .bold()
                                        .font(.system(size:UIConstants.TextSize.largeBody))
                                        .foregroundColor(.white)
                                    
                                    Text(localizedKey: "woman")
                                        .font(.system(size:UIConstants.TextSize.body))
                                        .lineLimit(3)
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .background(Color(.Color.colorAccent))
                            .cornerRadius(UIConstants.CornerRadius.large)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .overlay(
                                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.large)
                                    .strokeBorder(
                                        LinearGradient(
                                            gradient: Gradient(colors:  [.Color.colorBlueStart, .Color.colorControlSelected]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        lineWidth: 3
                                    )
                            )
                            VStack {
                                Spacer()
                                HStack {
                                    Text("😔")
                                        .font(.system(size: 40))
                                        .rotationEffect(.degrees(-20))
                                        .offset(x: -16, y: 16)
                                    Spacer()
                                }
                            }
                        }.padding(.horizontal, 16)
                        
                        Text(localizedKey: "good_prompt")
                            .font(.system(size: UIConstants.TextSize.subtitle))
                            .foregroundColor(.white)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        
                        
                        ZStack {
                            HStack(spacing:UIConstants.Padding.medium) {
                                
                                VStack(alignment: .leading,spacing:UIConstants.Padding.small) {
                                    
                                    Text(localizedKey: "enter_your_prompt")
                                        .bold()
                                        .font(.system(size:UIConstants.TextSize.largeBody))
                                        .foregroundColor(.white)
                                    
                                    Text(localizedKey: "prompt14")
                                    
                                    
                                        .font(.system(size:UIConstants.TextSize.body))
                                    
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }.padding( 12)
                                
                                Image("img_tutorial_risewoman")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 126)
                                    .clipShape(RoundedCorner(radius: UIConstants.CornerRadius.medium, corners: [.topRight, .bottomRight]))
                            }
                            .background(Color(.Color.colorAccent))
                            .cornerRadius(UIConstants.CornerRadius.large)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .overlay(
                                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.large)
                                    .strokeBorder(
                                        LinearGradient(
                                            gradient: Gradient(colors:  [.Color.colorBlueStart, .Color.colorControlSelected]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        lineWidth: 3
                                    )
                            )
                            VStack {
                                Spacer()
                                HStack {
                                    Text("🥳")
                                        .font(.system(size: 40))
                                        .rotationEffect(.degrees(-20))
                                        .offset(x: -16, y: 16)
                                    Spacer()
                                }
                            }
                        }.padding(.horizontal, 16)
                        
                        Text(localizedKey: "how_to_create_effective")
                            .bold()
                            .font(.system(size: 16))
                            .foregroundStyle(Color.white)
                            .multilineTextAlignment(.leading)
                            .frame(width: .infinity, alignment: .leading)
                        
                        Text("specify_object")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 10/255, green: 210/255, blue: 220/255))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(2)
                        Text("such_as_a_cat")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .bold()
                        
                        Text("detailed_description")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 10/255, green: 210/255, blue: 220/255))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(2)
                        Text("such_as_smile")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .bold()
                        
                        Text("image_type")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 10/255, green: 210/255, blue: 220/255))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(2)
                        Text("such_as_photo")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .bold()
                        
                        Text("style_reference")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 10/255, green: 210/255, blue: 220/255))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(2)
                        Text("type_the_desired_style")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .bold()
                            .padding(1)
                        
                        Text("don_t_worry_if_you")
                            .font(.system(size: 14))
                            .foregroundColor(.orange)
                            .bold()
                    }
                }.padding(.horizontal, UIConstants.Padding.medium)
                
            }
        }
}

#Preview {
    SupportScreen()
}
