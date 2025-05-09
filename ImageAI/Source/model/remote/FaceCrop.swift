//
//  FaceCrop.swift
//  ImageAI
//
//  Created by Boss on 08/05/2025.
//

import Foundation

struct FaceCrop: Decodable, Encodable , Equatable, Hashable{
    var images: [String]
    
    init(images: [String]) {
        self.images = images
    }
}
