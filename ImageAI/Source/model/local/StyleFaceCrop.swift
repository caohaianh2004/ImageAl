//
//  StyleFaceCrop.swift
//  ImageAI
//
//  Created by Boss on 07/05/2025.
//

import Foundation

struct StyleFaceCrop:  Identifiable, Codable, Hashable{
    let id: Int
    let imageName: String
    let parentId: Int?
}

class Facecrop: ObservableObject {
    @Published var facecrop: [StyleFaceCrop] = []
    init(Datafacecrop: [StyleFaceCrop]) {
        self.facecrop = Datafacecrop
    }
}

let dsFaceCrop = [
    StyleFaceCrop(id: 4, imageName: "https://static.aiease.ai/faceSwap%2Fmulti1_2_crop_1.png", parentId: 33),
    StyleFaceCrop(id: 5, imageName: "https://static.aiease.ai/faceSwap%2Fmulti1_2_crop_2.png", parentId: 33),
    StyleFaceCrop(id: 6, imageName: "https://static.aiease.ai/faceSwap%2Fmulti2_5_crop_1.png", parentId: 21),
    StyleFaceCrop(id: 33, imageName: "https://static.aiease.ai/faceSwap%2Fmulti2_5_crop_2.png", parentId: 21),
    StyleFaceCrop(id: 66, imageName: "https://static.aiease.ai/faceSwap%2Fmulti2_5_crop_3.png", parentId: 21),
    StyleFaceCrop(id: 35, imageName: "https://static.aiease.ai/faceSwap%2Fmulti2_5_crop_4.png", parentId: 21),
    StyleFaceCrop(id: 23, imageName: "https://static.aiease.ai/faceSwap%2Fmulti2_5_crop_5.png", parentId: 21),
    StyleFaceCrop(id: 65, imageName: "https://static.aiease.ai/faceSwap%2Fmulti3_2_crop_1.png", parentId: 54),
    StyleFaceCrop(id: 87, imageName: "https://static.aiease.ai/faceSwap%2Fmulti3_2_crop_2.png", parentId: 54),
    StyleFaceCrop(id: 64, imageName: "https://static.aiease.ai/faceSwap%2Fmulti4_2_crop_1.png", parentId: 12),
    StyleFaceCrop(id: 231, imageName: "https://static.aiease.ai/faceSwap%2Fmulti4_2_crop_2.png", parentId: 12),
    StyleFaceCrop(id: 11, imageName: "https://static.aiease.ai/faceSwap%2Fmulti5_2_crop_1.png", parentId: 73),
    StyleFaceCrop(id: 76, imageName: "https://static.aiease.ai/faceSwap%2Fmulti5_2_crop_2.png", parentId: 73),
    StyleFaceCrop(id: 98, imageName: "https://static.aiease.ai/faceSwap%2Fmulti6_2_crop_1.png", parentId: 98),
    StyleFaceCrop(id: 63, imageName: "https://static.aiease.ai/faceSwap%2Fmulti6_2_crop_2.png", parentId: 98)
]

let danhSach = Facecrop(Datafacecrop: dsFaceCrop)
