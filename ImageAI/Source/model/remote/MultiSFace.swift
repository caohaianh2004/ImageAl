//
//  MultiSFace.swift
//  ImageAI
//
//  Created by Boss on 29/04/2025.
//

import Foundation

struct MultiSFace: Decodable, Encodable , Equatable, Hashable {
    var original: String
    var images: [String]
    
    init(original: String, images: [String]) {
        self.original = original
        self.images = images
    }
}
