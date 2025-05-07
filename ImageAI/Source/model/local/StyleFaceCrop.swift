//
//  StyleFaceCrop.swift
//  ImageAI
//
//  Created by Boss on 07/05/2025.
//

import Foundation

struct StyleFaceCrop:  Identifiable, Codable, Hashable{
    let id: UUID
    let imageName: String
    let parentId: Int
    
}

class Facecrop: ObservableObject {
    @Published var facecrop: [StyleFaceCrop] = []
    init(Datafacecrop: [StyleFaceCrop]) {
        self.facecrop = Datafacecrop
    }
}

let dsFaceCrop = [
    StyleFaceCrop(id: UUID(), imageName: "https://static.aiease.ai/faceSwap%2Fmulti1_2_crop_1.png", parentId: 33),
    StyleFaceCrop(id: UUID(), imageName: "https://static.aiease.ai/faceSwap%2Fmulti1_2_crop_2.png", parentId: 33),
    StyleFaceCrop(id: UUID(), imageName: <#T##String#>, parentId: 21),
    StyleFaceCrop(id: UUID(), imageName: <#T##String#>, parentId: 21),
    StyleFaceCrop(id: UUID(), imageName: <#T##String#>, parentId: 21),
    StyleFaceCrop(id: UUID(), imageName: <#T##String#>, parentId: 21),
    StyleFaceCrop(id: UUID(), imageName: <#T##String#>, parentId: 21),
    StyleFaceCrop(id: UUID(), imageName: <#T##String#>, parentId: <#T##Int#>),
    StyleFaceCrop(id: UUID(), imageName: <#T##String#>, parentId: <#T##Int#>),
    StyleFaceCrop(id: UUID(), imageName: <#T##String#>, parentId: <#T##Int#>),
    StyleFaceCrop(id: UUID(), imageName: <#T##String#>, parentId: <#T##Int#>),
    StyleFaceCrop(id: UUID(), imageName: <#T##String#>, parentId: <#T##Int#>),
]
