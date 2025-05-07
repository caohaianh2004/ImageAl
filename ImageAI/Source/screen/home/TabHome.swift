//
//  TabHome.swift
//  ImageAI
//
//  Created by DoanhMac on 7/3/25.
//

import Foundation
import SwiftUI

enum TabType: String, CaseIterable {
    case generate = "abc_generates"
//    case textToImage = "text_to_image"
    case swapface = "abc_swap"
    case imageToText = "image_to_image"
    case enhance = "abc_tab_echance"
    case restore = "abc_tab_restore"
    
}

struct TabHome : Identifiable, Hashable {
    var id:UUID = .init()
    var title: String
    var type: TabType
    var icon: String
    var width:CGFloat = 0
    var minX:CGFloat = 0
    
}

var tabs_: [TabHome] = [
    .init(title: TabType.generate.rawValue, type: .generate, icon: "wand.and.rays.inverse"),
//   .init(title: TabType.textToImage.rawValue, type: .textToImage, icon: "photo.on.rectangle.angled"),
    .init(title: TabType.swapface.rawValue, type: .swapface, icon: "theatermasks.fill"),
    .init(title: TabType.imageToText.rawValue, type: .imageToText, icon: "square.and.arrow.up.circle.fill"),
    .init(title: TabType.enhance.rawValue, type: .enhance, icon: "lasso.badge.sparkles"),
    .init(title: TabType.restore.rawValue, type: .restore, icon: "tray.2")
]

