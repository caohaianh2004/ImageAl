//
//  ShimmerEffect.swift
//  ImageAI
//
//  Created by DoanhMac on 11/3/25.
//

import SwiftUI

struct ShimmerEffect: View {
    private var gradientColors: [Color] = [.Color.colorShimmerStart.opacity(0.5),.Color.colorShimmerEnd.opacity(0.5), .Color.colorShimmerStart.opacity(0.5)]
    @State var startPoint: UnitPoint = .init(x:-1.8, y: -1.2)
    @State var endPoint: UnitPoint = .init(x:0, y: -0.2)
    
    var body: some View {
        LinearGradient(colors: gradientColors, startPoint: startPoint, endPoint: endPoint)
            .onAppear {
                withAnimation(.easeInOut(duration: 1)
                    .repeatForever(autoreverses: false)) {
                        self.startPoint = .init(x:1, y: 1)
                        self.endPoint = .init(x:2.2, y: 2.2)
                       
                    }
           
            }
    }
    
}

#Preview {
    ShimmerEffect()
}
