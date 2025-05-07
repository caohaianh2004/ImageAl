//
//  TranslateNew.swift
//  ImageAI
//
//  Created by DoanhMac on 14/3/25.
//

import Foundation
import UIKit



class TranslateNew {
    
    static func translate(
        langFrom: String,
        langTo: String,
        textToTranslate: String?,
        translateSuccess: @escaping (String) -> Void,
        translateError: @escaping (String) -> Void
    ) {
        
        
        guard let text = textToTranslate, !text.isEmpty else {
            translateError("Translation error occurred")
            return
        }
        
        var translateFreeTaskMultiThread: TranslateFreeTaskMultiThreadNew = TranslateFreeTaskMultiThreadNew(source: langFrom, target: langTo)
        translateFreeTaskMultiThread.setDataTranslate(text: text)
        translateFreeTaskMultiThread = TranslateFreeTaskMultiThreadNew(source: langFrom, target: langTo)
        translateFreeTaskMultiThread.setDataTranslate(text: text)
        translateFreeTaskMultiThread.translateText(onSuccess: {textTrans in
            translateSuccess(textTrans)
        }, onError: {textError in
            translateError(textError)
        })
    }
    
}

