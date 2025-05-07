//
//  Swapface.swift
//  ImageAI
//
//  Created by Boss on 22/04/2025.
//

import Foundation

struct SwapFace: Decodable, Encodable , Equatable, Hashable {
    var originals: [String]
    var faces: [String]
    
    init(originals: [String], faces: [String]) {
        self.originals = originals
        self.faces = faces
    }
    
}
