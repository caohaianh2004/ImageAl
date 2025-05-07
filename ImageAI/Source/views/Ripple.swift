//
//  Ripple.swift
//  ImageAI
//
//  Created by DoanhMac on 7/3/25.
//

import Foundation
import SwiftUI

struct Ripple: ViewModifier {
    // MARK: Lifecycle

    init(rippleColor: Color, isCircle:Bool) {
        self.color = rippleColor
        self.isCircle = isCircle
    }

    // MARK: Internal

    let color: Color
    let isCircle:Bool

    @State private var scale: CGFloat = 0.5
    
    @State private var animationPosition: CGFloat = 0.0
    @State private var x: CGFloat = 0.0
    @State private var y: CGFloat = 0.0
    
    @State private var opacityFraction: CGFloat = 0.0
    
    let timeInterval: TimeInterval = 0.5
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            if isCircle {
                ZStack {
    //                Circle()
    //                    .foregroundColor(.gray.opacity(0.05))
                    
                    Circle()
                        .foregroundColor(color)
                        .opacity(0.2*opacityFraction)
                        .scaleEffect(scale)
                        .offset(x: x, y: y)
                    content
                }
                .onTapGesture(perform: { location in
                    x = location.x-geometry.size.width/2
                    y = location.y-geometry.size.height/2
                    opacityFraction = 1.0
                    withAnimation(.linear(duration: timeInterval)) {
                        scale = 3.0*(max(geometry.size.height, geometry.size.width)/min(geometry.size.height, geometry.size.width))
                        opacityFraction = 0.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
                            scale = 1.0
                            opacityFraction = 0.0
                        }
                    }
                })
                .clipShape(Circle())
                .clipped()
            } else {
                ZStack {
    //                Circle()
    //                    .foregroundColor(.gray.opacity(0.05))
                    
                    Rectangle()
                        .foregroundColor(color)
                        .opacity(0.2*opacityFraction)
                        .scaleEffect(scale)
                        .offset(x: x, y: y)
                    content
                }
                .onTapGesture(perform: { location in
                    x = location.x-geometry.size.width/2
                    y = location.y-geometry.size.height/2
                    opacityFraction = 1.0
                    withAnimation(.linear(duration: timeInterval)) {
                        scale = 3.0*(max(geometry.size.height, geometry.size.width)/min(geometry.size.height, geometry.size.width))
                        opacityFraction = 0.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
                            scale = 1.0
                            opacityFraction = 0.0
                        }
                    }
                })
                .clipShape(RoundedRectangle(cornerRadius: UIConstants.Padding.large))
                .clipped()
            }
           
        }
    }
}

extension View {
    func rippleEffect(rippleColor: Color = .Color.appBackground, isCircle:Bool = true) -> some View {
        modifier(Ripple(rippleColor: rippleColor, isCircle: isCircle))
    }
}



