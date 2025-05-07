//
//  SampleDataEnhance.swift
//  ImageAI
//
//  Created by DoanhMac on 18/3/25.
//

import SwiftUI
import Foundation

struct SampleEnhanceData : Codable{
    let imageUrlFirst:String
    let imageUrlSecond:String
    let size:Int?
    let category:String?
    let styleId:Int?
    
    init(imageUrlFirst: String, imageUrlSecond: String, size: Int? = nil, category: String? = nil, styleId: Int? = nil) {
        self.imageUrlFirst = imageUrlFirst
        self.imageUrlSecond = imageUrlSecond
        self.size = size
        self.category = category
        self.styleId = styleId
    }
}

extension SampleEnhanceData {
    static func getListSample() -> [SampleEnhanceData] {
        return [
            SampleEnhanceData(
                imageUrlFirst: "\(LINK_SERVER)/imageai/enhance/256webp/enhance_example_1.webp",
                imageUrlSecond: "\(LINK_SERVER)/imageai/enhance/256webp/enhance_example_2.webp",
                size: 2,
                category: "general"
            ),
            SampleEnhanceData(
                imageUrlFirst: "\(LINK_SERVER)/imageai/enhance/256webp/enhance_example_4.webp",
                imageUrlSecond: "\(LINK_SERVER)/imageai/enhance/256webp/enhance_example_3.webp",
                size: 4,
                category: "anime"
            ),
            SampleEnhanceData(
                imageUrlFirst: "\(LINK_SERVER)/imageai/enhance/256webp/enhance_example_5.webp",
                imageUrlSecond: "\(LINK_SERVER)/imageai/enhance/256webp/enhance_example_6.webp",
                size: 4,
                category: "old_photo"
            ),
            SampleEnhanceData(
                imageUrlFirst: "\(LINK_SERVER)/imageai/enhance/256webp/enhance_example_7.webp",
                imageUrlSecond: "\(LINK_SERVER)/imageai/enhance/256webp/enhance_example_8.webp",
                size: 2,
                category: "general"
            )
        ]
    }
    
    static func getListSampleRestore() -> [SampleEnhanceData] {
        return [
            SampleEnhanceData(
                imageUrlFirst: "\(LINK_SERVER)/imageai/enhance/256webp/recolor_11.webp",
                imageUrlSecond: "\(LINK_SERVER)/imageai/enhance/256webp/recolor_1.webp",
                size: -1,
                category: "restore_recolor"
            ),
            SampleEnhanceData(
                imageUrlFirst: "\(LINK_SERVER)/imageai/enhance/256webp/recolor_22.webp",
                imageUrlSecond: "\(LINK_SERVER)/imageai/enhance/256webp/recolor_2.webp",
                size: -1,
                category: "restore"
            ),
            SampleEnhanceData(
                imageUrlFirst: "\(LINK_SERVER)/imageai/enhance/256webp/recolor_33.webp",
                imageUrlSecond: "\(LINK_SERVER)/imageai/enhance/256webp/recolor_3.webp",
                size: -1,
                category: "recolor"
            ),
            SampleEnhanceData(
                imageUrlFirst: "\(LINK_SERVER)/imageai/enhance/256webp/recolor_44.webp",
                imageUrlSecond: "\(LINK_SERVER)/imageai/enhance/256webp/recolor_4.webp",
                size: -1,
                category: "restore_recolor"
            ),
        ]
    }
}


struct EnhanceDataModel :  Codable {
    let id:Int
    let imageUrl:String
    let category:String?
    let prompt:String?
    
    init(id: Int, imageUrl: String, category: String?, prompt: String?) {
        self.id = id
        self.imageUrl = imageUrl
        self.category = category
        self.prompt = prompt
    }
}

extension EnhanceDataModel {
    static func getListEnhanceData() -> [EnhanceDataModel] {
        return [
            EnhanceDataModel(
                id: 1,
                imageUrl: "\(LINK_SERVER)/imageai/enhance/256webp/enhance_featue_1.webp",
                category: "abc_general",
                prompt: "abc_general_prompt"
            ),
            EnhanceDataModel(
                id: 2,
                imageUrl: "\(LINK_SERVER)/imageai/enhance/256webp/enhance_featue_2.webp",
                category: "abc_anime",
                prompt: "abc_anime_prompt"
            ),
            EnhanceDataModel(
                id: 3,
                imageUrl: "\(LINK_SERVER)/imageai/enhance/256webp/enhance_featue_3.webp",
                category: "abc_old_photo",
                prompt: "abc_old_photo_prompt"
            )
        ]
    }
}


