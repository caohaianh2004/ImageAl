import SwiftUI

struct ScrollTextView: View {
    @Binding var text: String
    @Binding var clickEnable: Bool
    @Binding var isHorizontal: Bool
    @Binding var speed: Double
    @Binding var textSize: CGFloat
    @Binding var textColor: Color
    @Binding var textBackColor: Color
    @Binding var needScrollTimes: Int
    @Binding var isScrollForever: Bool
    
    @State private var offsetX: CGFloat = 0
    @State private var isPaused: Bool = false
    @State private var textWidth: CGFloat = 0
    @State private var isAnimating: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                textBackColor
                
                Text(text)
                    .font(.system(size: textSize, weight: .bold))
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: true, vertical: false)
                    .background(
                        GeometryReader { textGeometry in
                            Color.clear
                                .onAppear {
                                    updateTextWidth(textGeometry.size.width, frameWidth: geometry.size.width)
                                }
                                .onChange(of: text) { _, _ in
                                    updateTextWidth(textGeometry.size.width, frameWidth: geometry.size.width)
                                }
                        }
                    )
                    .offset(x: offsetX)
                    .onTapGesture {
                        if clickEnable {
                            isPaused.toggle()
                            if isPaused {
                                stopScrolling()
                            } else {
                                startScrolling(frameWidth: geometry.size.width)
                            }
                        }
                    }
            }
            .clipped()
            .frame(maxWidth: .infinity, maxHeight: textSize * 1.5, alignment: .center)
        }
    }
    
    private func updateTextWidth(_ newWidth: CGFloat, frameWidth: CGFloat) {
        guard newWidth > 0 else { return }
        textWidth = newWidth
        if isHorizontal, !text.isEmpty, !isAnimating {
            startScrolling(frameWidth: frameWidth)
        }
    }
    
    private func startScrolling(frameWidth: CGFloat) {
        guard !isPaused, frameWidth > 0, textWidth > 0, !isAnimating else { return }
        
        let totalDistance = frameWidth + textWidth
        offsetX = frameWidth
        isAnimating = true
        
        withAnimation(
            Animation.linear(duration: speed * Double(totalDistance / 100))
                .repeatCount(isScrollForever ? .max : needScrollTimes, autoreverses: false)
        ) {
            offsetX = -textWidth
        }
    }
    
    private func stopScrolling() {
        isAnimating = false
        offsetX = 0
    }
}

