//
//  QwenRequest.swift
//  ImageAI
//
//  Created by DoanhMac on 18/3/25.
//

import Foundation

struct QwenRequest:  Decodable, Encodable {
    let message:String
    let chat_id:String
    let base64:String
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decode(String.self, forKey: .message)
        self.chat_id = try container.decode(String.self, forKey: .chat_id)
        self.base64 = try container.decode(String.self, forKey: .base64)
    }
    init (message:String? = nil,chat_id:String,base64:String){
        self.message = message ?? "Generate a detailed AI image generation prompt from this image.No further explanation"
        self.chat_id = chat_id
        self.base64 = base64
    }
    
    
}



struct QwenResponse  : Decodable{
    let status:Bool
    let data:String
}

struct QwenResponseNewId : Decodable{
    let status:Bool
    let uuid:String
}
