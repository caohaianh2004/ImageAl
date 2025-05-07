//
//  GenerateButtonView.swift
//  ImageAI
//
//  Created by DoanhMac on 10/3/25.
//

import SwiftUI

struct GenerateButtonView: View {
    let isShowBackground: Bool
    let actionButton: () -> ()
    var titleButton : String = "abc_generate"
    
    var body: some View {
        
        Button {
            actionButton()
        } label: {
            Text(localizedKey: titleButton)
                .fontWeight(.bold)
                .font(.system(size: UIConstants.TextSize.subtitle, weight: .bold, design: .default))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity ,alignment: .top)
                .padding(.vertical, UIConstants.Padding.large)
                .background(isShowBackground ? Color(.Color.colorTextSelected) : Color(.Color.colorButtonNotEvent))
                .clipShape(RoundedRectangle(cornerRadius: UIConstants.CornerRadius.large))
            
        }
        
    }
}

struct GenerateButtonView_Previews: PreviewProvider {
    static var previews: some View {
        GenerateButtonView(
            isShowBackground: true,
            actionButton: { })
    }
    
}


