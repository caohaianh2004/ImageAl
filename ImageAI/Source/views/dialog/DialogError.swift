//
//  DialogError.swift
//  ImageAI
//
//  Created by DoanhMac on 25/3/25.
//

import SwiftUI


struct DialogError: View {
    let actionButton: () -> Void
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
            VStack {
                
                Spacer()
                VStack(alignment: .leading, spacing: UIConstants.Padding.large) {
                    Text(localizedKey: "error_policy_title")
                        .font(.system(size: UIConstants.TextSize.title))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    Spacer().frame(height: UIConstants.Padding.superSmall)
                    
                    Text(localizedKey: "error_policy_content")
                        .font(.system(size: UIConstants.TextSize.subtitle))
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                    
                    
                    GenerateButtonView(isShowBackground: true, actionButton: {
                        actionButton()
                    }, titleButton: "regenaral_image")
                    
                }
                .padding(UIConstants.Padding.large)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.Color.colorAccent)
                .clipShape(RoundedCorner(radius: UIConstants.CornerRadius.medium))
            }
        }
        
            
            
            
        
    }
}
#Preview {
    DialogError(actionButton: {
        
    })
}

