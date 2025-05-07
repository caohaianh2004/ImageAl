//
//  StyleSwapFace.swift
//  ImageAI
//
//  Created by Boss on 24/04/2025.
//

import Foundation

struct StyleSwapFace: Identifiable, Codable, Hashable {
    var id: Int
    var genden: String
    var imageName: String
    
    init(id: Int,genden: String, imageName: String) {
        self.id = id
        self.genden = genden
        self.imageName = imageName
    }
}
class SwapfaceModel: ObservableObject {
    @Published var  swapface: [StyleSwapFace] = []
    init(Dataswapface: [StyleSwapFace]) {
        self.swapface = Dataswapface
    }
}

let dsSwapface = [
    StyleSwapFace( 
        id: 21,
        genden: "Man",
        imageName: "https://static.aiease.ai/faceSwap%2Fman21.webp"
    ),
    StyleSwapFace(
        id: 20,
        genden: "Man",
        imageName: "https://static.aiease.ai/faceSwap%2Fman20.webp"
    ),
    StyleSwapFace( 
        id: 19,
        genden: "Man",
        imageName: "https://static.aiease.ai/faceSwap%2Fman19.webp"
    ),
    StyleSwapFace(
        id:18,
        genden: "Man",
        imageName: "https://static.aiease.ai/faceSwap%2Fman18.webp"
    ),
    StyleSwapFace(
        id: 17,
        genden: "Man",
        imageName: "https://static.aiease.ai/faceSwap%2Fman17.webp"
    ),
    StyleSwapFace(
        id: 16,
        genden: "Man",
        imageName: "https://static.aiease.ai/faceSwap%2Fman16.webp"
    ),
    StyleSwapFace(
        id: 15,
        genden: "Man",
        imageName: "https://static.aiease.ai/faceSwap%2Fman15.webp"
    ),
    StyleSwapFace(
        id: 14,
        genden: "Man",
        imageName: "https://static.aiease.ai/faceSwap%2Fman14.webp"
    ),
    StyleSwapFace(
        id: 13,
        genden: "Man",
        imageName: "https://static.aiease.ai/faceSwap%2Fman13.webp"
    ),
    StyleSwapFace(
        id: 12,
        genden: "Man",
        imageName: "https://static.aiease.ai/faceSwap%2Fman12.webp"
    ),
    StyleSwapFace(
        id: 11,
        genden: "Man",
        imageName:  "https://static.aiease.ai/faceSwap%2Fman11.webp"
    ),
    StyleSwapFace(
        id: 2,
        genden: "Man",
        imageName: "https://static.aiease.ai/faceSwap%2Fman2.webp"
    ),
    StyleSwapFace(
        id: 3,
        genden: "Man",
        imageName:  "https://static.aiease.ai/faceSwap%2Fman3.webp"
    ),
    StyleSwapFace(
        id: 4,
        genden: "Man",
        imageName:  "https://static.aiease.ai/faceSwap%2Fman4.webp"
    ),
    StyleSwapFace(
        id: 5,
        genden: "Man",
        imageName: "https://static.aiease.ai/faceSwap%2Fman5.webp"
    ),
    StyleSwapFace(
        id: 7,
        genden: "Man",
        imageName: "https://static.aiease.ai/faceSwap%2Fman7.webp"
    ),
    StyleSwapFace(
        id: 8,
        genden: "Man",
        imageName: "https://static.aiease.ai/faceSwap%2Fman8.webp"
    ),
    StyleSwapFace(
        id: 9,
        genden: "Man",
        imageName: "https://static.aiease.ai/faceSwap%2Fman9.webp"
    ),
    StyleSwapFace(
        id: 10,
        genden: "Man",
        imageName:  "https://static.aiease.ai/faceSwap%2Fman10.webp"
    ),
    StyleSwapFace(
        id: 59,
        genden: "Woman",
        imageName: "https://static.aiease.ai/faceSwap%2Fwoman59.webp"
    ),
    StyleSwapFace(
        id: 58,
        genden: "Woman",
        imageName:  "https://static.aiease.ai/faceSwap%2Fwoman58.webp"
    ),
    StyleSwapFace(
        id: 57,
        genden: "Woman",
        imageName: "https://static.aiease.ai/faceSwap%2Fwoman57.webp"
    ),
    StyleSwapFace(
        id: 56,
        genden: "Woman",
        imageName:  "https://static.aiease.ai/faceSwap%2Fwoman56.webp"
    ),
    StyleSwapFace(
        id: 55,
        genden: "Woman",
        imageName:  "https://static.aiease.ai/faceSwap%2Fwoman55.webp"
    ),
    StyleSwapFace(
        id: 54,
        genden: "Woman",
        imageName: "https://static.aiease.ai/faceSwap%2Fwoman54.webp"
    ),
    StyleSwapFace(
        id: 53,
        genden: "Woman",
        imageName: "https://static.aiease.ai/faceSwap%2Fwoman53.webp"
    ),
    StyleSwapFace(
        id: 52,
        genden: "Woman",
        imageName:  "https://static.aiease.ai/faceSwap%2Fwoman52.webp"
    ),
    StyleSwapFace(
        id: 51,
        genden: "Woman",
        imageName:  "https://static.aiease.ai/faceSwap%2Fwoman51.webp"
    ),
]

let danhsach = SwapfaceModel(Dataswapface: dsSwapface)
