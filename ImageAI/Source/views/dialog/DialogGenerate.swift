//
//  DialogGenerate.swift
//  ImageAI
//
//  Created by DoanhMac on 11/3/25.
//

import SwiftUI

struct DialogGenerate: View {
   let title: String
    let actionDismiss: () -> ()
    let actionConfirm: () -> ()
    
    var body: some View {
        ZStack {
            VStack(spacing: UIConstants.Padding.small) {
                HStack {
                    Spacer()
                    Button {
                        actionDismiss()
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
                Text(title)
                    .fontWeight(.bold)
                    .font(.system(size: UIConstants.TextSize.titleDialog, weight: .bold, design: .default))
                    .foregroundColor(.white)
                
                Text("dialog_watch_ads_remove_logo")
                    .fixedSize(horizontal: false, vertical: true)
                    .fontWeight(.regular)
                    .font(.system(size: UIConstants.TextSize.subtitleDialog, weight: .regular, design: .default))
                    .lineLimit(nil)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                     
                
                Spacer().frame(height: UIConstants.Padding.large)
                
                Button {
                    actionConfirm()
                    actionDismiss()
                } label: {
                    HStack {
                        Spacer()
                        Image("ic_ads")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.Color.colorPrimary)
                            .frame(width: UIConstants.sizeIconMedium, height: UIConstants.sizeIconMedium)
                            .padding(UIConstants.Padding.medium)
                        VStack {
                            Text("dialog_create_art")
                                .font(.system(size: UIConstants.TextSize.largeBody, weight: .bold))
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .foregroundColor(.Color.colorPrimary)
                            Text("dialog_watch_ads")
                                .font(.system(size: UIConstants.TextSize.body, weight: .bold))
                                .fontWeight(.regular)
                                .lineLimit(1)
                                .foregroundColor(.Color.colorPrimary)
                        }
                        Spacer()
                        Spacer()
                        
                    }
                }
                .padding([.horizontal], UIConstants.Padding.medium)
                .padding(.vertical, UIConstants.Padding.superSmall)
                .frame(maxWidth: .infinity)
                .background(content: {
                    RoundedRectangle(cornerRadius: UIConstants.CornerRadius.extraLarge)
                        .fill(Color(.Color.colorTextSelected))
                })
                
                Spacer().frame(height: UIConstants.Padding.small)
                
                Button {
                    
                } label: {
                    HStack {
                        Spacer()
                  
                        Image("ic_premium")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.Color.colorPrimary)
                            .frame(width: UIConstants.sizeIconMedium, height: UIConstants.sizeIconMedium)
                            .padding(UIConstants.Padding.medium)
                        VStack {
                            Text("dialog_switch_pro")
                                .font(.system(size: UIConstants.TextSize.largeBody, weight: .bold))
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .foregroundColor(.Color.colorPrimary)
                            Text("menu_premium")
                                .font(.system(size: UIConstants.TextSize.body, weight: .bold))
                                .fontWeight(.regular)
                                .lineLimit(1)
                                .foregroundColor(.Color.colorPrimary)
                          
                        }
                        Spacer()
                        Spacer()
                        
                    }
                }
                .padding([.horizontal], UIConstants.Padding.medium)
                .padding(.vertical, UIConstants.Padding.superSmall)
                .frame(maxWidth: .infinity)
                .background(content: {
                    RoundedRectangle(cornerRadius: UIConstants.CornerRadius.extraLarge)
                        .fill(Color(.Color.colorArange))
                })
                
                Spacer()
                
            }.padding(UIConstants.Padding.large)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: UIConstants.CornerRadius.extraLarge)
                    .fill(Color(.Color.colorAccent)))
                .padding(UIConstants.Padding.superSmall)
                .fixedSize(horizontal: false, vertical: true)
        }.frame( maxWidth: .infinity, maxHeight: .infinity).background(.black.opacity(0.5)).onTapGesture {
            actionDismiss()
        }
        
        
        
    }
}

#Preview {
    DialogGenerate(title: "") {
        
    } actionConfirm: {
        
    }

}
