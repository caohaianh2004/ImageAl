//
//  EaseCreateRequest.swift
//  ImageAI
//
//  Created by DoanhMac on 13/3/25.
//

import Foundation
import SwiftUI

struct EaseCreateRequest : Decodable, Encodable, Equatable, Hashable {
    let prompt: String
    let size: String
    let style: Int
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.prompt = try container.decode(String.self, forKey: .prompt)
        self.size = try container.decode(String.self, forKey: .size)
        self.style = try container.decode(Int.self, forKey: .style)
    }
    init (prompt: String, size: String, style: Int) {
        self.prompt = prompt
        self.size = size
        self.style = style
    }
}

class EaseCreateResponse : Decodable  {
    let success: Bool
    let sessionId:String
    
    init(success: Bool, sessionId: String) {
        self.success = success
        self.sessionId = sessionId
    }
    
}


