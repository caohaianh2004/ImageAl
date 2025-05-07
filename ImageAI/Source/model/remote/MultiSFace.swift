//
//  MultiSFace.swift
//  ImageAI
//
//  Created by Boss on 29/04/2025.
//

import Foundation

struct MultiSFace: Decodable, Encodable , Equatable, Hashable {
    var face: [String]
    var imageName: [String]
    
    init(face: [String], imageName: [String]) {
        self.face = face
        self.imageName = imageName
    }
}
