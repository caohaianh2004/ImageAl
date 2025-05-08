//
//  FaceCrop.swift
//  ImageAI
//
//  Created by Boss on 08/05/2025.
//

import Foundation

struct FaceCrop: Decodable, Encodable , Equatable, Hashable{
    var imageName: [String]
    
    init(imageName: [String]) {
        self.imageName = imageName
    }
}
