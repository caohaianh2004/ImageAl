//
//  ConverImage.swift
//  ImageAI
//
//  Created by DoanhMac on 21/3/25.
//

import SwiftUI
import Foundation
import UIKit
import MessageUI

func saveImageToDocuments(image: UIImage) -> String? {
    guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
    let fileName = UUID().uuidString + ".jpg"
    let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
    
    do {
        try data.write(to: fileURL)
        return fileURL.path
    } catch {
        print("Error saving image: \(error.localizedDescription)")
        return nil
    }
}
func loadImageFromDocuments(path: String) -> UIImage? {
    let fileURL = URL(fileURLWithPath: path)
    
    do {
        let imageData = try Data(contentsOf: fileURL)
        return UIImage(data: imageData)
    } catch {
        print("Error loading image: \(error.localizedDescription)")
        return nil
    }
}

func fileURL(for imageURL: String) -> URL? {
    if imageURL.hasPrefix("/") {
        return URL(fileURLWithPath: imageURL)
    } else {
        do {
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            return documentsDirectory.appendingPathComponent(imageURL)
        } catch {
            print("Error retrieving document directory: \(error)")
            return nil
        }
    }
}

