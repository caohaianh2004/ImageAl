//
//  HTTPMethod.swift
//  ImageAI
//
//  Created by DoanhMac on 13/3/25.
//
import Foundation
import SwiftUI

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum APIEndpoint {
    case createImageEase
    case getTaskEase
    case createQwenId
    case getTaskQwen
    case createEnhanceSession
    case getTaskEnhance
    case creaeteRestore
    case headshort
    case multiface
    case facecrop
    case swapface
    
    var path: String {
        switch self {
        case .createImageEase: return "aiease/t2i"
        case .getTaskEase: return "aiease/get_task"
        case .createQwenId :  return "qwenlm/new"
        case .getTaskQwen: return "qwenlm/i2t"
        case .createEnhanceSession: return "aiease/enhance-photo"
        case .getTaskEnhance: return "aiease/get_task"
        case .creaeteRestore: return "aiease/restore-photo"
        case .headshort: return "aiease/generate-headshot"
        case .multiface: return "aiease/face-swap-muti"
        case .facecrop: return "aiease/face-crop"
        case .swapface: return "aiease/swap-face"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createImageEase: return .post
        case .getTaskEase: return .post
        case .createQwenId: return .post
        case .getTaskQwen: return .post
        case .createEnhanceSession: return .post
        case .getTaskEnhance: return .post
        case .creaeteRestore: return .post
        case .headshort: return .post
        case .multiface: return .post
        case.facecrop: return .post
        case .swapface: return .post
        }
    }
}
