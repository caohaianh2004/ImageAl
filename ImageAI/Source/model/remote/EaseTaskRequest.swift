//
//  EaseTaskRequest.swift
//  ImageAI
//
//  Created by DoanhMac on 13/3/25.
//

import Foundation
import SwiftUI

class EaseTaskRequest : Decodable, Encodable {
    let processId: String
    
    init(processId: String) {
        self.processId = processId
    }
}

class EaseTaskResponse : Decodable{
    let success: Bool
    let  data: [EaseItem]
    
    init(success: Bool, data: [EaseItem]) {
        self.success = success
        self.data = data
    }
    
    
}

struct EaseItem : Decodable, Equatable, Hashable {
    let index: Int
    let nsfw: Bool
    let origin:String
    let thumb:String
    
    init(index: Int, nsfw: Bool, origin: String, thumb: String) {
        self.index = index
        self.nsfw = nsfw
        self.origin = origin
        self.thumb = thumb
    }
    
    
    
}
