//
//  CardItemCanvas.swift
//  ImageAI
//
//  Created by DoanhMac on 10/3/25.
//

import SwiftUI


struct CanvasItemCanvas: View {
    let canvas: CanvasData
    let isSelected: Bool 
    
    var body: some View {
        HStack(spacing:UIConstants.Padding.large) {
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.large)
                .fill(Color.clear)
                .aspectRatio(canvas.aspectRatio, contentMode: .fit)
                .overlay(
                    RoundedRectangle(cornerRadius: UIConstants.CornerRadius.small)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [.Color.colorPrimary, .Color.colorPrimary]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 1
                        )
                )   .frame(width: UIConstants.sizeCardCanvas, height: UIConstants.sizeCardCanvas)

            Text(localizedKey: canvas.title)
                .font(.system(size: 13))
                .bold()
                .padding(.top, UIConstants.Padding.superSmall)
        }
        .padding(.horizontal, UIConstants.Padding.extraLarge)
        .padding( .vertical, UIConstants.Padding.medium)
        .foregroundColor(.Color.colorPrimary)
        .background(isSelected ? Color(.Color.colorTextSelected) : Color(.Color.colorAccent))
        .clipShape(RoundedRectangle(cornerRadius: UIConstants.CornerRadius.large))
    }
}

struct CanvasItemCanvas_Previews: PreviewProvider {
    static var previews: some View {
        CanvasItemCanvas(canvas: .init(title: "Preview", aspectRatio: 1), isSelected: false)
    }
}


