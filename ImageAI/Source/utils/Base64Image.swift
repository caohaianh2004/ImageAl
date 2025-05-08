//
//  Base64Image.swift
//  ImageAI
//
//  Created by DoanhMac on 18/3/25.
//

import SwiftUI
import Foundation
import Kingfisher


class Base64Image {
    static func base64EncodeImage(_ image: UIImage) async -> String {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                    continuation.resume(returning: "")
                    return
                }
                let base64encodedImage = imageData.base64EncodedString()
                continuation.resume(returning: base64encodedImage)
            }
        }
    }
    static func base64DecodeToImage(_ base64: String) -> UIImage? {
           guard let data = Data(base64Encoded: base64),
                 let image = UIImage(data: data) else {
               return nil
           }
           return image
       }
    
}

func loadImageFromURL(_ urlString: String, completion: @escaping (UIImage?) -> Void) {
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }

    KingfisherManager.shared.retrieveImage(with: url) { result in
        switch result {
        case .success(let value):
            completion(value.image)
        case .failure(_):
            completion(nil)
        }
    }
}


class ImageResizer {
    static func getNewSizeBtm(maxWidth: Int, maxHeight: Int, width: Int, height: Int) -> (Int, Int) {
        let maxW = min(maxWidth, 1080)
        let maxH = min(maxHeight, 1920)
        
        let widthTemp = min(width, maxW)
        let heightTemp = min(height, maxH)
        
        if width >= height {
            if width > widthTemp {
                let newHeight = (widthTemp * height) / width
                return (widthTemp, newHeight)
            } else {
                return (width, height)
            }
        } else {
            if height > heightTemp {
                let newWidth = (heightTemp * width) / height
                return (newWidth, heightTemp)
            } else {
                return (width, height)
            }
        }
    }

    static  func getResizedBitmap(image: UIImage, newWidth: Int, newHeight: Int, isNecessaryToKeepOrig: Bool) -> UIImage? {
        let size = CGSize(width: newWidth, height: newHeight)

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if !isNecessaryToKeepOrig {
            Logger.success("Ảnh gốc có thể bị loại bỏ nếu không cần thiết.")
        }

        return resizedImage
    }
}

