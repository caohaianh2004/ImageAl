//
//  FaceSwapButtonView.swift
//  ImageAI
//
//  Created by Boss on 22/04/2025.
//

import SwiftUI

struct FaceSwapButtonView: View {
    let isShowButton: Bool
    let actionButton: () -> ()
    var titleButton : String = "face_swap"
    
    var body: some View {
        Button {
            actionButton()
        }label: {
            Text(localizedKey: titleButton)
                .fontWeight(.bold)
                .font(.system(size: UIConstants.TextSize.buttonfaceswap, weight: .bold, design: .default))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity ,alignment: .top)
                .padding(.vertical, UIConstants.Padding.large)
                .background(isShowButton ? Color(.Color.colorTextSelected) : Color(.Color.colorButtonNotEvent))
                .cornerRadius(UIConstants.CornerRadius.buttonFaceSwap)
                .padding()
        }
    }
}

struct FaceSwapButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FaceSwapButtonView(
            isShowButton: true,
            actionButton: { })
    }
    
}
