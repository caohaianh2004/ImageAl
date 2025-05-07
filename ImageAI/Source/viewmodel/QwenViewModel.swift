//
//  QwenViewModel.swift
//  ImageAI
//
//  Created by DoanhMac on 18/3/25.
//

import SwiftUI
import Foundation

@MainActor
class QwenViewModel: ObservableObject {
    private var fetchTask: Task<Void, Never>?
    private let repository: AppRepositoryProtocol
    @Published private(set) var  state: QwenState = QwenState()
    
    init(repository: AppRepositoryProtocol) {
        self.repository = repository
    }
    
    func createQwenId(_ uiImage:UIImage) async  {
        state = QwenState(isLoading: true)
        Task {
            let  arrNewSize = ImageResizer.getNewSizeBtm(maxWidth: 256, maxHeight: 256, width: Int(uiImage.size.width), height: Int(uiImage.size.height))
            let newUIImage = ImageResizer.getResizedBitmap(image: uiImage, newWidth: arrNewSize.0, newHeight: arrNewSize.1, isNecessaryToKeepOrig: false)!
            let base64String = await Base64Image.base64EncodeImage(newUIImage)
            Logger.success(base64String)
            let result = await repository.createNewIdQwen()
            
            switch result {
            case .success(let idQwen):
                 getPromptResult(uuid: idQwen.uuid, base64: base64String)
            case .failure(let error):
                state = QwenState(isLoading: false,error: error.localizedDescription)
            }
            
        }
    }
    func getPromptResult(uuid: String, base64:String) {
        fetchTask?.cancel()
        fetchTask = Task {
            while !Task.isCancelled {
                do {
                    let qwenRequest: QwenRequest = QwenRequest(chat_id: uuid, base64: base64)
                    let result =  await repository.getTaskQwen(qwenTaskRequest: qwenRequest)
                    
                    switch result {
                    case .success(let data):
                        Logger.success("Data received: \(data.data)")
                        let translatedText = try await translateText(text: data.data, source: "en", target: UserDefaults.standard.string(forKey: KEY_SELECTED_LANGUAGE_CODE) ?? "")
                        Logger.success("Translate success: \(translatedText)")
                        state = QwenState(isLoading: false, promptResult: translatedText)
                        return
                        
                    case .failure(let error):
                        Logger.error("CreateImage error: \(error.localizedDescription)")
                        state = QwenState(isLoading: false, error: error.localizedDescription)
                        return
                    }
                } catch is CancellationError {
                    Logger.error("GetImages: Task Cancelled")
                    return
                } catch {
                    state = QwenState(isLoading: false, error: error.localizedDescription)
                    Logger.error("GetImages: Unexpected error \(error)")
                    return
                }
            }
        }
    }
    
    private func translateText(text: String, source: String, target: String) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            TranslateNew.translate(langFrom: source, langTo: target, textToTranslate: text, translateSuccess: { translatedText in
                continuation.resume(returning: translatedText)
            }, translateError: { error in
                continuation.resume(throwing: NSError(domain: "TranslationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Translation failed"]))
            })
        }
    }
    
    func cancelTask() {
        fetchTask?.cancel()
        fetchTask = nil
    }
    
}



struct  QwenState {
    let isLoading: Bool
    let error: String?
    let promptResult: String?
    
    init(isLoading: Bool = false, error: String? = nil,   promptResult: String? = nil) {
        self.isLoading = isLoading
        self.error = error
        self.promptResult = promptResult
    }
    
    
}
