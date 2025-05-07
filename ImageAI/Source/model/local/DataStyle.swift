//
//  DataStyle.swift
//  ImageAI
//
//  Created by DoanhMac on 12/3/25.
//

import Foundation

import SwiftUI

struct DataStyle: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let styleId: Int
}
extension DataStyle {
    static func getAllStyle() -> [DataStyle] {
        return [
            DataStyle(title: NSLocalizedString("style_photo", comment: ""), styleId: 1),
            DataStyle(title: NSLocalizedString("style_art", comment: ""),  styleId: 6),
            DataStyle(title: NSLocalizedString("style_cartoon", comment: ""),  styleId: 14),
            DataStyle(title: NSLocalizedString("style_game", comment: ""), styleId: 22),
            DataStyle(title: NSLocalizedString("style_logo", comment: ""),  styleId: 27),
            DataStyle(title: NSLocalizedString("style_tattoo", comment: ""),  styleId: 32),
            DataStyle(title: NSLocalizedString("style_icon", comment: ""),  styleId: 34),
            DataStyle(title: NSLocalizedString("style_text", comment: ""), styleId: 36),
            DataStyle(title: NSLocalizedString("style_sticker", comment: ""),  styleId: 40)
        ]
    }
}
