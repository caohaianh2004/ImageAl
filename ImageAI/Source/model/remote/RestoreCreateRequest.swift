//
//  RestoreCreateRequest.swift
//  ImageAI
//
//  Created by DoanhMac on 19/3/25.
//

import SwiftUI
import Foundation

struct RestoreCreateRequest: Decodable, Encodable , Equatable, Hashable {
    let restore_type: String
    let images:[String]
    
    init(restore_type: String, images: [String]) {
        self.restore_type = restore_type
        self.images = images
    }
}
