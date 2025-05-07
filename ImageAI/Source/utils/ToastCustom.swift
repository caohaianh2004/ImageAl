//
//  ToastCustom.swift
//  ImageAI
//
//  Created by DoanhMac on 25/3/25.
//

import SwiftUI
import PopupView

struct ToastBottomCustom: View {
    let localizedKeyTitle: String
    let iconToast: String = "exclamationmark.warninglight.fill"
    let colorIcon: Color = Color(.yellow)
    var body: some View {
            HStack(alignment: .center){
                Image(systemName: iconToast)
                    .resizable()
                    .renderingMode(.template).foregroundColor(colorIcon)
                    
                    .frame(width: UIConstants.sizeIconMedium, height: UIConstants.sizeIconMedium)
                
                Text(localizedKey: localizedKeyTitle)
                    .foregroundColor(.black)
                    .font(.system(size: UIConstants.TextSize.body))
                    .padding(UIConstants.Padding.large)
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
                
                
                
                
            }
            .padding(.horizontal, UIConstants.Padding.medium)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, UIConstants.Padding.medium)
            .background(Color(hex: "FFFFFF"))
            .clipShape(RoundedCorner(radius: 12))
            .opacity(0.8)
        
    }
}

enum PopupType {
    case ratio
    case prompt
    case valid
    case image

    var isRatio: Bool {
        self == .ratio
    }

    var isPrompt: Bool {
        self == .prompt
    }

    var isValid: Bool {
        self == .valid
    }

    var isImage: Bool {
        self == .image
    }

    var isVisible: Bool {
        true
    }
}


//#Preview {
//    ToastTopFirst()
//}

