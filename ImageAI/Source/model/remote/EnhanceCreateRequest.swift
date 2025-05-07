//
//  EnhanceCreateRequest.swift
//  ImageAI
//
//  Created by DoanhMac on 18/3/25.
//

import SwiftUI
import Foundation

struct EnhanceCreateRequest: Decodable, Encodable , Equatable, Hashable{
    let mode:String
    let size:Int
    let images:[String]
    
    init(mode: String, size: Int, images: [String]) {
        self.mode = mode
        self.size = size
        self.images = images
    }
}

struct EnhanceTaskRequest : Decodable, Encodable {
    let processId:String
    
    init(processId: String) {
        self.processId = processId
    }
}

struct EnhanceCreateResponse : Decodable, Encodable {
    let success: Bool
    let sessionId:String
}

struct EnhanceTaskResponse : Decodable {
    let success: Bool
    let data: [EaseItem]
}




