//
//  TranslateFreeTaskMultiThreadNew.swift
//  ImageAI
//
//  Created by DoanhMac on 14/3/25.
//

import Foundation
import UIKit


class TranslateFreeTaskMultiThreadNew {
    private let source: String
    private let target: String
    private var textToTranslate: String?
    private let queue = DispatchQueue(label: "ApiHandlerQueue", qos: .background)
    
    init(source: String, target: String) {
        self.source = source
        self.target = target
    }
    
    func setDataTranslate(text: String?) {
        self.textToTranslate = text
    }
    
    func translateText(onSuccess: @escaping (String) -> Void,onError: @escaping (String) -> Void) {
        guard let text = textToTranslate, !text.isEmpty else {
            onError("Translation error occurred")
            return
        }
        
        queue.async {
            let urlString = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=\(self.source)&tl=\(self.target)&dt=t&ie=UTF-8&oe=UTF-8&q=\(text)"
            guard let url = URL(string: urlString) else {
                DispatchQueue.main.async {
                    onError("Invalid URL")
                }
                return
            }
            
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                
                guard let data = data, error == nil else {
                    DispatchQueue.main.async {
                        onError("Translation error occurred")
                        
                    }
                    return
                }
                
                do {
                    guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Any],
                          let firstArray = jsonArray.first as? [Any] else {
                        DispatchQueue.main.async {
                            onError("Translation error occurred")
                        }
                        return
                    }
                    
                    var combinedText = ""
                    
                    
                    for item in firstArray {
                        if let innerArray = item as? [Any],
                           let translatedText = innerArray.first as? String {
                            combinedText += translatedText + " "
                        }
                    }
                    
                    DispatchQueue.main.async {
                        onSuccess(combinedText.trimmingCharacters(in: .whitespaces))
                    }
                } catch {
                    DispatchQueue.main.async {
                        onError("Translation error occurred: \(error.localizedDescription)")
                    }
                }
                
                
                
                
            }
            task.resume()
        }
    }
}
