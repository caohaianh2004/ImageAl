//
//  StyleMultiFace.swift
//  ImageAI
//
//  Created by Boss on 29/04/2025.
//

import Foundation

struct StyleMultiFace: Identifiable, Codable, Hashable {
    var id: Int
    var imageName: String
    
    init(id: Int, imageName: String) {
        self.id = id
        self.imageName = imageName
    }
}

class MultiFace: ObservableObject {
    @Published var multiface: [StyleMultiFace] = []
    
    init(Datamultiface: [StyleMultiFace]) {
        self.multiface = Datamultiface
    }
}

let dsMultiface = [
    StyleMultiFace(id: 33,imageName: "https://static.aiease.ai/faceSwap%2Fmulti1_2.webp"),
    StyleMultiFace(id: 21,imageName: "https://static.aiease.ai/faceSwap%2Fmulti2_5.webp"),
    StyleMultiFace(id: 54,imageName: "https://static.aiease.ai/faceSwap%2Fmulti3_2.webp"),
    StyleMultiFace(id: 12,imageName: "https://static.aiease.ai/faceSwap%2Fmulti4_2.webp"),
    StyleMultiFace(id: 73,imageName: "https://static.aiease.ai/faceSwap%2Fmulti5_2.webp"),
    StyleMultiFace(id: 98,imageName: "https://static.aiease.ai/faceSwap%2Fmulti6_2.webp"),
]

let ds = MultiFace(Datamultiface: dsMultiface)
