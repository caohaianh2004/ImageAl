//
//  HeadShort.swift
//  ImageAI
//
//  Created by Boss on 28/03/2025.
//

import Foundation
import SwiftUI

struct HeadShort: Decodable, Encodable , Equatable, Hashable {
    let size: String
    let style : Int
    let images : [String]
    
    init(size: String, style: Int, images: [String]) {
        self.size = size
        self.style = style
        self.images = images
    }
}
