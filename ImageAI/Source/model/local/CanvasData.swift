//
//  CanvasData.swift
//  ImageAI
//
//  Created by DoanhMac on 10/3/25.
//

import Foundation
import SwiftUI

struct CanvasData: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let aspectRatio: CGFloat
}

extension CanvasData {
    static func getDataCanvas() -> [CanvasData] {
        return [
            CanvasData(title: "1:1", aspectRatio: 1.0),
            CanvasData(title: "3:4", aspectRatio: 3/4),
            CanvasData(title: "2:3", aspectRatio: 2/3),
            CanvasData(title: "3:2", aspectRatio: 3/2),
            CanvasData(title: "4:3", aspectRatio: 4/3),
            CanvasData(title: "3:5", aspectRatio: 3/5),
            CanvasData(title: "4:5", aspectRatio: 4/5),
            CanvasData(title: "5:4", aspectRatio: 5/4),
            CanvasData(title: "9:16", aspectRatio: 9/16),
            CanvasData(title: "16:9", aspectRatio: 16/9),
        ]
    }
}
