//
//  DialogImageDetail.swift
//  ImageAI
//
//  Created by DoanhMac on 14/3/25.
//

import SwiftUI
import Kingfisher


struct DialogImageDetail: View {
    let imageUIImage:UIImage
    let sizeCanvas: CGFloat
    let actionClose: () -> ()
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(alignment: .leading, spacing: UIConstants.Padding.large) {
                HStack {
                 
                    Button {
                        actionClose()
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
                    
                    Spacer()
                }
                Spacer()
                Image(uiImage: imageUIImage)
                    .resizable()
                    .aspectRatio(sizeCanvas, contentMode: .fit)
                    .cornerRadius(UIConstants.CornerRadius.large)
                    .padding(.horizontal, UIConstants.Padding.medium)
                  
                Spacer()
            }
        }
        
    }
}


//#Preview {
//    DialogImageDetail()
//}
