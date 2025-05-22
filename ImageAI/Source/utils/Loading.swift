//
//  Loading.swift
//  ImageAI
//
//  Created by Boss on 21/05/2025.
//

import SwiftUI

struct Loading: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Circle()
                    .trim(from: 0.0, to: 0.9)
                    .stroke(Color.white, style: StrokeStyle(lineWidth: 6, dash: [10,20]))
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                    .onAppear {
                        isAnimating = true
                    }
                    .padding()
                Text("ĐANG XỬ LÝ ẢNH...")
                    .foregroundColor(.white)
                    .bold()
                    .font(.system(size: 12))
            }
            .padding(32)
            .background(Color.blue.opacity(0.75))
            .cornerRadius(20)
        }
    }
}

#Preview {
    Loading()
}
