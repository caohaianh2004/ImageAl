//
//  ScrollOffset.swift
//  ImageAI
//
//  Created by DoanhMac on 7/3/25.
//

import Foundation
import SwiftUI


extension View {
    @ViewBuilder
    func offsetX(completion: @escaping (CGRect) -> ()) -> some View {
        self
            .overlay {
                GeometryReader { proxy in
                    let rect = proxy.frame(in: .global)
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: rect)
                        .onPreferenceChange(OffsetKey.self,perform: completion)
                }
            }
    }
}


struct OffsetKey: PreferenceKey {
    static let defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue:() -> CGRect) {
        value = nextValue()
    }
}
