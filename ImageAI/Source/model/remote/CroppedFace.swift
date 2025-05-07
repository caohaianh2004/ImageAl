//
//  CroppedFace.swift
//  ImageAI
//
//  Created by Boss on 06/05/2025.
//

import Foundation

struct CroppedFace: Decodable, Encodable , Equatable {
    var id: Int
    var rect: CGRect
    
    init(id: Int, rect: CGRect) {
        self.id = id
        self.rect = rect
    }
}
