//
//  StyleHeadShot.swift
//  ImageAI
//
//  Created by Boss on 31/03/2025.
//

import Foundation
import SwiftUI

struct StyleHeadShot: Identifiable, Codable, Hashable {
    var id: Int
    var sort: Int
    var style: String
    var gender: String
    var avatar: String
    var head_show: Bool?
    
    init(id: Int, sort: Int, style: String, gender: String, avatar: String, head_show: Bool? = nil) {
        self.id = id
        self.sort = sort
        self.style = style
        self.gender = gender
        self.avatar = avatar
        self.head_show = head_show
    }
}

class HeadShots: ObservableObject {
    @Published var headshot: [StyleHeadShot] 
    
    init(Dataheadshot: [StyleHeadShot]) {
        self.headshot = Dataheadshot
        
        do {
            let jsonData = try JSONEncoder().encode(Dataheadshot)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }
        } catch {
            print("Error encoding JSON: \(error)")
        }
    }
}

let dsheadshot: [StyleHeadShot] = [
    StyleHeadShot(
        id: 21,
        sort: 21,
        style: "Professional",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_21_face_Face_woman_0005_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 7,
        sort: 7,
        style: "Professional",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_7_face_Face_man_0002_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 146,
        sort: 170,
        style: "Professional",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F170.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 144,
        sort: 168,
        style: "Professional",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F168.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 26,
        sort: 26,
        style: "Professional",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_26_face_Face_woman_0006_batch_0.webp",
        head_show: true
    ),
    StyleHeadShot(
        id: 6,
        sort: 6,
        style: "Professional",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_6_face_Face_man_0008_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 2,
        sort: 2,
        style: "Professional",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_2_face_Face_man_0005_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 13,
        sort: 13,
        style: "Professional",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_13_face_Face_man_0009_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 1,
        sort: 1,
        style: "Professional",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_1_face_Face_man_0009_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 136,
        sort: 160,
        style: "Professional",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F160.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 8,
        sort: 8,
        style: "Professional",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_8_face_Face_man_0001_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 5,
        sort: 5,
        style: "Professional",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_5_face_Face_man_0001_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 10,
        sort: 10,
        style: "Professional",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_10_face_Face_man_0008_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 3,
        sort: 3,
        style: "Professional",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_3_face_Face_man_0009_batch_1.webp",
        head_show: true
    ),
    StyleHeadShot(
        id: 20,
        sort: 20,
        style: "Professional",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_20_face_Face_woman_0007_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 14,
        sort: 14,
        style: "Professional",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_14_face_Face_man_0005_batch_0.webp",
        head_show: true
    ),
    StyleHeadShot(
        id: 25,
        sort: 25,
        style: "Professional",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_25_face_Face_woman_0004_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 4,
        sort: 4,
        style: "Professional",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_4_face_Face_man_0006_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 27,
        sort: 27,
        style: "Professional",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_27_face_Face_woman_0007_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 11,
        sort: 11,
        style: "Professional",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_11_face_Face_man_0009_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 24,
        sort: 24,
        style: "Professional",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_24_face_Face_woman_0001_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 22,
        sort: 22,
        style: "Professional",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_22_face_Face_woman_0000_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 18,
        sort: 18,
        style: "Professional",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_18_face_Face_woman_0004_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 19,
        sort: 19,
        style: "Professional",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_19_face_Face_woman_0003_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 23,
        sort: 23,
        style: "Professional",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_23_face_Face_woman_0005_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 28,
        sort: 28,
        style: "Professional",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_28_face_Face_woman_0005_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 12,
        sort: 12,
        style: "Professional",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_12_face_Face_man_0006_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 17,
        sort: 17,
        style: "Professional",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_17_face_Face_woman_0005_batch_1.webp",
        head_show: true
    ),
    StyleHeadShot(
        id: 9,
        sort: 9,
        style: "Professional",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_9_face_Face_man_0005_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 90,
        sort: 112,
        style: "Creative",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_112_face_Face_woman_0005_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 177,
        sort: 201,
        style: "Creative",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F201.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 150,
        sort: 174,
        style: "Creative",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F174.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 172,
        sort: 196,
        style: "Creative",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F196.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 148,
        sort: 172,
        style: "Creative",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F172.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 140,
        sort: 164,
        style: "Creative",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F164.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 153,
        sort: 177,
        style: "Creative",
        gender: "Woman", 
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F177.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 164,
        sort: 188,
        style: "Creative",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F188.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 161,
        sort: 185,
        style: "Creative",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F185.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 167,
        sort: 191,
        style: "Creative",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F191.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 91,
        sort: 113,
        style: "Creative",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_113_face_Face_woman_0004_batch_1.webp", 
        head_show: false
    ),
    StyleHeadShot(
        id: 147,
        sort: 171,
        style: "Creative",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F171.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 166,
        sort: 190,
        style: "Creative",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F190.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 92,
        sort: 114,
        style: "Creative",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_114_face_Face_woman_0004_batch_1.webp",
        head_show: true
    ),
    StyleHeadShot(
        id: 84,
        sort: 105,
        style: "Creative",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_105_face_Face_woman_0005_batch_1.webp", 
        head_show: false
    ),
    StyleHeadShot(
        id: 95,
        sort: 117,
        style: "Creative",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_117_face_Face_woman_0007_batch_0.webp", 
        head_show: false
    ),
    StyleHeadShot(
        id: 141,
        sort: 165,
        style: "Creative",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F165.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 94,
        sort: 116,
        style: "Creative",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_116_face_Face_woman_0007_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 159,
        sort: 183,
        style: "Creative",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F183.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 139,
        sort: 163,
        style: "Creative",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F163.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 138,
        sort: 162,
        style: "Creative",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F162.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 83,
        sort: 104,
        style: "Creative",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_104_face_Face_woman_0004_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 157,
        sort: 181,
        style: "Creative",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F181.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 165,
        sort: 189,
        style: "Creative",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F189.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 156,
        sort: 180,
        style: "Creative",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F180.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 160,
        sort: 184,
        style: "Creative",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F184.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 87,
        sort: 108,
        style: "Creative",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_108_face_Face_man_0008_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 142,
        sort: 166,
        style: "Creative",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F166.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 162,
        sort: 186,
        style: "Creative",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F186.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 169,
        sort: 193,
        style: "Creative",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F193.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 178,
        sort: 202,
        style: "Creative",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F202.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 168,
        sort: 192,
        style: "Creative",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F192.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 179,
        sort: 203,
        style: "Creative",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F203.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 42,
        sort: 43,
        style: "Art",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_43_face_Face_woman_0009_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 158,
        sort: 182,
        style: "Art",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F182.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 39,
        sort: 40,
        style: "Art",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_40_face_Face_woman_0007_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 35,
        sort: 36,
        style: "Art",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_36_face_Face_man_0009_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 45,
        sort: 46,
        style: "Art",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_46_face_Face_woman_0007_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 41,
        sort: 42,
        style: "Art",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_42_face_Face_woman_0009_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 44,
        sort: 45,
        style: "Art",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_45_face_Face_woman_0004_batch_1.webp",
        head_show: true
    ),
    StyleHeadShot(
        id: 98,
        sort: 120,
        style: "Art",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_120_face_Face_woman_0002_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 93,
        sort: 115,
        style: "Art",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_115_face_Face_woman_0007_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 149,
        sort: 173,
        style: "Art",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F173.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 34,
        sort: 34,
        style: "Art",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_34_face_Face_man_0006_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 40,
        sort: 41,
        style: "Art",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_41_face_Face_woman_0003_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 97,
        sort: 119,
        style: "Art",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_119_face_Face_woman_0009_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 43,
        sort: 44,
        style: "Art",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_44_face_Face_woman_0003_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 31,
        sort: 31,
        style: "Art",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_31_face_Face_man_0006_batch_1.webp",
        head_show: true
    ),
    StyleHeadShot(
        id: 145,
        sort: 169,
        style: "Art",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F169.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 48,
        sort: 49,
        style: "Art",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_49_face_Face_woman_0009_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 96,
        sort: 118,
        style: "Art",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_118_face_Face_woman_0007_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 33,
        sort: 33,
        style: "Art",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_33_face_Face_man_0001_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 36,
        sort: 37,
        style: "Art",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_37_face_Face_man_0005_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 32,
        sort: 32,
        style: "Art",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_32_face_Face_man_0003_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 86,
        sort: 107,
        style: "Art",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_107_face_Face_man_0008_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 143,
        sort: 167,
        style: "Art",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F167.webp",
        head_show: false),
    StyleHeadShot(
        id: 111,
        sort: 135,
        style: "Casual",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F135.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 30,
        sort: 30,
        style: "Casual",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_30_face_Face_woman_0001_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 133,
        sort: 157,
        style: "Casual",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F157.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 116,
        sort: 140,
        style: "Casual",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F140.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 112,
        sort: 136,
        style: "Casual",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F136.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 137,
        sort: 161,
        style: "Casual",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F161.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 117,
        sort: 141,
        style: "Casual",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F141.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 115,
        sort: 139,
        style: "Casual",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F139.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 130,
        sort: 154,
        style: "Casual",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F154.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 163,
        sort: 187,
        style: "Casual",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F187.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 114,
        sort: 138,
        style: "Casual",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F138.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 113,
        sort: 137,
        style: "Casual",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F137.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 16,
        sort: 16,
        style: "Casual",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_16_face_Face_man_0005_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 110,
        sort: 134,
        style: "Casual",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F134.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 15,
        sort: 15,
        style: "Casual",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_15_face_Face_man_0001_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 29,
        sort: 29,
        style: "Casual",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_29_face_Face_woman_0003_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 52,
        sort: 53,
        style: "Yearbook",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_53_face_Face_woman_0009_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 55,
        sort: 56,
        style: "Yearbook",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_56_face_Face_man_0004_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 57,
        sort: 58,
        style: "Yearbook",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_58_face_Face_man_0005_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 49,
        sort: 50,
        style: "Yearbook",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_50_face_Face_woman_0003_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 101,
        sort: 124,
        style: "Yearbook",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_124_face_Face_woman_0004_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 56,
        sort: 57,
        style: "Yearbook",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_57_face_Face_woman_0004_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 100,
        sort: 123,
        style: "Yearbook",
        gender: "Woman",
        avatar:  "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_123_face_Face_woman_0003_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 53,
        sort: 54,
        style: "Yearbook",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_54_face_Face_woman_0003_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 54,
        sort: 55,
        style: "Yearbook",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_55_face_Face_man_0004_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 51,
        sort: 52,
        style: "Yearbook",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_52_face_Face_man_0005_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 50,
        sort: 51,
        style: "Yearbook",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_51_face_Face_man_0002_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 77,
        sort: 85,
        style: "Christmas",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_85_face_Face_woman_0004_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 151,
        sort: 175,
        style: "Christmas",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F175.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 135,
        sort: 159,
        style: "Christmas",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F159.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 80,
        sort: 91,
        style: "Christmas",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_91_face_Face_woman_0005_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 176,
        sort: 200,
        style: "Christmas",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F200.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 152,
        sort: 176,
        style: "Christmas",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F176.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 155,
        sort: 179,
        style: "Christmas",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F179.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 131,
        sort: 155,
        style: "Christmas",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F155.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 82,
        sort: 97,
        style: "Christmas",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_97_face_Face_man_0001_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 174,
        sort: 198,
        style: "Christmas",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F198.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 175,
        sort: 199,
        style: "Christmas",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F199.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 81,
        sort: 95,
        style: "Christmas",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_95_face_Face_woman_0002_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 134,
        sort: 158,
        style: "Christmas",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F158.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 154,
        sort: 178,
        style: "Christmas",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F178.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 107,
        sort: 132,
        style: "Christmas",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_132_face_Face_woman_0009_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 106,
        sort: 130,
        style: "Christmas",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_130_face_Face_woman_0007_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 170,
        sort: 194,
        style: "Christmas",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F194.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 132,
        sort: 156,
        style: "Christmas",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F156.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 173,
        sort: 197,
        style: "Christmas",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F197.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 171,
        sort: 195,
        style: "Christmas",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F195.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 65,
        sort: 66,
        style: "Halloween",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_66_face_Face_woman_0007_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 72,
        sort: 77,
        style: "Halloween",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_77_face_Face_woman_0005_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 122,
        sort: 146,
        style: "Halloween",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F146.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 126,
        sort: 150,
        style: "Halloween",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F150.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 89,
        sort: 110,
        style: "Halloween",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_110_face_Face_man_0001_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 125,
        sort: 149,
        style: "Halloween",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F149.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 118,
        sort: 142,
        style: "Halloween",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F142.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 71,
        sort: 76,
        style: "Halloween",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_76_face_Face_man_0004_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 74,
        sort: 79,
        style: "Halloween",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_79_face_Face_man_0008_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 67,
        sort: 70,
        style: "Halloween",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_70_face_Face_man_0005_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 121,
        sort: 145,
        style: "Halloween",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F145.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 70,
        sort: 74,
        style: "Halloween",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_74_face_Face_man_0005_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 73,
        sort: 78,
        style: "Halloween",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_78_face_Face_woman_0009_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 76,
        sort: 81,
        style: "Halloween",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_81_face_Face_woman_0009_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 128,
        sort: 152,
        style: "Halloween",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F152.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 99,
        sort: 121,
        style: "Halloween",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_121_face_Face_woman_0006_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot(
        id: 119,
        sort: 143,
        style: "Halloween",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F143.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 66,
        sort: 68,
        style: "Halloween",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_68_face_Face_woman_0007_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 127,
        sort: 151,
        style: "Halloween",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F151.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 129,
        sort: 153,
        style: "Halloween",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F153.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 120,
        sort: 144,
        style: "Halloween",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F144.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 75,
        sort: 80,
        style: "Halloween",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_80_face_Face_woman_0009_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 109,
        sort: 75,
        style: "Halloween",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_75_face_Face_woman_0004_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 88,
        sort: 109,
        style: "Halloween",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_109_face_Face_woman_0003_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 123,
        sort: 147,
        style: "Halloween",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F147.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 124,
        sort: 148,
        style: "Halloween",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2F148.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 68,
        sort: 72,
        style: "Halloween",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_72_face_Face_man_0008_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 69,
        sort: 73,
        style: "Halloween",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_73_face_Face_woman_0001_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 85,
        sort: 106,
        style: "Halloween",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_106_face_Face_woman_0005_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 38,
        sort: 39,
        style: "Anime",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_39_face_Face_man_0004_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 47,
        sort: 48,
        style: "Anime",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_48_face_Face_woman_0004_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 46,
        sort: 47,
        style: "Anime",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_47_face_Face_woman_0009_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 37,
        sort: 38,
        style: "Anime",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_38_face_Face_man_0008_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 79,
        sort: 89,
        style: "Easter",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_89_face_Face_woman_0006_batch_0.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 78,
        sort: 88,
        style: "Easter",
        gender: "Woman",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_88_face_Face_woman_0005_batch_1.webp",
        head_show: false
    ),
    StyleHeadShot (
        id: 108,
        sort: 133,
        style: "Easter",
        gender: "Man",
        avatar: "https://pub-static.aiease.ai/headshotAvatar%2Fstyle_133_face_Face_man_0009_batch_1.webp",
        head_show: false
    )
]

let heaShot = HeadShots(Dataheadshot: dsheadshot)

