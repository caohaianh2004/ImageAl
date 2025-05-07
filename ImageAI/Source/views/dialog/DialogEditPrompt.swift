//
//  DialogEditPrompt.swift
//  ImageAI
//
//  Created by DoanhMac on 11/3/25.
//

import SwiftUI

struct DialogEditPrompt: View {
    @State private var textPrompt: String = ""

    let textRequest : String
    let actionDismiss: () -> ()
    let actionGernerate: (String) -> ()
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                ZStack {
                    BackgroundDialogView()
                    
                    VStack(alignment: .leading, spacing: UIConstants.Padding.large) {
                        
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
                        Text("abc_choose_edit")
                            .font(.system(size: UIConstants.TextSize.largeBody, weight: .bold))
                            .fontWeight(.medium)
                            .foregroundColor(.gray.opacity(0.8))
                        
                        PromptEnterView(textPrompt: $textPrompt)
                        
                        Spacer()
                        
                        GenerateButtonView(
                            isShowBackground: false,
                            actionButton: {
                                actionGernerate(textPrompt)
                                actionDismiss()
                        })
                    }
                   
                    .padding(UIConstants.Padding.large)
                } .frame(height: UIScreen.main.bounds.height * 2 / 3).cornerRadius(12, corners: [.topLeft, .topRight])
            }
        }
        .onAppear(perform: {
            textPrompt = textRequest
        })
        .onTapGesture {
            actionDismiss()
        }
        
     
    }
}
struct PromptEnterView :View {
    @Binding  var textPrompt: String
    var body: some View {
        VStack(alignment: .leading, spacing: UIConstants.Padding.medium) {
            
            TextEditor(text: $textPrompt)
                .placeholder(when: textPrompt.isEmpty) {
                    Text(localizedKey:  "abc_enter_prom").font(.system(size: UIConstants.TextSize.largeBody)).foregroundColor(.Color.colorTextItemSettingDim)
                }
                .font(.system(size: UIConstants.TextSize.largeBody))
                .foregroundColor(.Color.colorPrimary)
                .fixedSize(horizontal: false, vertical: true)
                .fontWeight(.medium)
                .scrollContentBackground(.hidden)
                .frame(maxWidth: .infinity,minHeight: 56 ,maxHeight: 260, alignment: .top)
                .background(Color.clear)
            
            
            Color.clear.frame(height: UIConstants.Padding.extraLarge)
            
            HStack(
                alignment: .center
            ) {
                Spacer()
                if !textPrompt.isEmpty {
                    Image("ic_close")
                        .resizable()
                        .renderingMode(.template)
                        .padding(2)
                        .frame(width: UIConstants.sizeIconSmall, height:  UIConstants.sizeIconSmall)
                        .foregroundColor(.Color.colorPrimary)
                        .onTapGesture {
                            textPrompt = ""
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



#Preview {
    DialogEditPrompt(textRequest: "") {
        
    } actionGernerate: { String in
        
    }

}
