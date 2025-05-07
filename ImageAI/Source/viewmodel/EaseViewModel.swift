//
//  EaseViewModel.swift
//  ImageAI
//
//  Created by DoanhMac on 13/3/25.
//
import SwiftUI
import Foundation

@MainActor
public class EaseViewModel: ObservableObject {
    private let repository: AppRepositoryProtocol
    private var fetchTask: Task<Void, Never>?
    private var isSecondItemShown: Bool = false
    var currentDataList: [EaseItem] = []
    private var errorTask: Task<Void, Never>?
    @Published private(set) var state: EaseViewState = EaseViewState()
    
    init(repository: AppRepositoryProtocol) {
        self.repository = repository
    }
    
    func checkPrompt(txtPrompt: String, completion: @escaping (Any) -> Void) {
        updateState(isLoading: true)
        
        TranslateNew.translate(
            langFrom: "auto",
            langTo: "en",
            textToTranslate: txtPrompt
        ) { [weak self] translatedText in
            guard let self = self else { return }
            
            let forbiddenKeywords = self.findForbiddenKeywords(in: translatedText)
            if forbiddenKeywords.isEmpty {
                completion(translatedText)
            } else {
                self.handleForbiddenKeywords(
                    keywords: forbiddenKeywords,
                    originalText: translatedText,
                    completion: completion
                )
            }
        } translateError: { error in
            Logger.error("Translation failed: \(error)")
        }
    }
    
    func fetchCreateImages(request: EaseCreateRequest) async {
        updateState(isLoading: true)
        switch await repository.createImageEase(easeCreateRequest: request) {
        case .success(let data):
            Logger.success("Started image creation: \(data.sessionId)")
            getImageData(taskId: data.sessionId)
        case .failure(let error):
            updateState(error: error.localizedDescription)
        }
        
    }
    
    private func findForbiddenKeywords(in text: String) -> [String] {
        CheckPrompt.forbiddenKeywordsOri.filter { keyword in
            guard let regex = try? NSRegularExpression(
                pattern: "\\b\(NSRegularExpression.escapedPattern(for: keyword))\\b",
                options: .caseInsensitive
            ) else { return false }
            
            let range = NSRange(text.startIndex..<text.endIndex, in: text)
            return regex.firstMatch(in: text, range: range) != nil
        }
    }
    
    private func handleForbiddenKeywords(
        keywords: [String],
        originalText: String,
        completion: @escaping (Any) -> Void
    ) {
        let targetLang = UserDefaults.standard.string(forKey: KEY_SELECTED_LANGUAGE_CODE) ?? ""
        let keywordsString = keywords.joined(separator: ", ")
        
        TranslateNew.translate(
            langFrom: "en",
            langTo: targetLang,
            textToTranslate: keywordsString
        ) { [weak self] translatedKeywords in
            guard let self = self else { return }
            
            let combinedKeywords = keywords + translatedKeywords.split(separator: ", ").map(String.init)
            completion(combinedKeywords)
            
            if KEY_CHECK_SAFE_PROMPT {
                self.startErrorJob()
            } else {
                self.updateState(isLoading: false, error: "")
            }
        } translateError: { error in
            Logger.error("Translation failed: \(error)")
        }
    }
    
    private func startErrorJob() {
        errorTask?.cancel()
        errorTask = Task { [weak self] in
            guard let self = self else { return }
            
            do {
                for i in 0...10 {
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                    await MainActor.run {
                        self.state = EaseViewState(isLoading: true, progress: i * 10)
                    }
                }
                await MainActor.run {
                    self.state = EaseViewState(isLoading: false, error: "next_error", progress: 0)
                }
            } catch {
                Logger.error("Error task failed: \(error)")
            }
        }
    }
    
    private func updateState(
        isLoading: Bool = false,
        error: String = "",
        progress: Int = 0
    ) {
        state = EaseViewState(isLoading: isLoading, error: error, progress: progress)
    }
    
    func fetchCreateImages(easeCreateRequest: EaseCreateRequest) async {
        state = EaseViewState(isLoading: true)
        TranslateNew.translate(langFrom: UserDefaults.standard.string(forKey: KEY_SELECTED_LANGUAGE_CODE) ?? "",langTo: "en",  textToTranslate: easeCreateRequest.prompt ,translateSuccess: { [self] textTrans in
            Logger.success("Translate success: \(textTrans)")
            Task {
                let newRequest = EaseCreateRequest(prompt: textTrans, size: easeCreateRequest.size, style: easeCreateRequest.style)
                let result = await repository.createImageEase(easeCreateRequest: newRequest)
                
                
                switch result {
                case .success(let data):
                    Logger.success("Start create image \(data.sessionId)")
                    getImageData(taskId: data.sessionId)
                case .failure(let error):
                    self.state = EaseViewState(error: error.localizedDescription)
                }
            }
        }, translateError: { _ in
            Logger.error("Translate error")
        })
    }
    
    
    
    func getImageData(taskId: String) {
        fetchTask?.cancel()
        fetchTask = Task {
            var progress = 1
            
            while !Task.isCancelled {
                do {
                    let result = await repository.getTaskEase(easeTaskRequest: EaseTaskRequest(processId: taskId))
                    
                    switch result {
                    case .success(let data):
                        let jsonString = String(data: data, encoding: .utf8) ?? ""
                        if  jsonString.contains(EaseStatus.pending.rawValue) ||  jsonString.contains(EaseStatus.error.rawValue) {
                            Logger.error("GetImages: \(taskId) Pending")
                            progress = min(progress + 10, 99)
                            state = EaseViewState(isLoading:true ,progress: progress)
                            try await Task.sleep(nanoseconds: 5_000_000_000)
                            continue
                        }
                        Logger.success("getImages Success: \(data)")
                        let dataResult =  try JSONDecoder().decode(EaseTaskResponse.self, from: data)
                        currentDataList.removeAll()
                        currentDataList = dataResult.data
                        state = EaseViewState(data: dataResult.data,progress: 100)
                        return
                    case .failure(let error):
                        Logger.error("CreateImage error: \(error.localizedDescription)")
                        state = EaseViewState(isLoading: false, error: error.localizedDescription)
                        return
                    }
                } catch is CancellationError {
                    Logger.error("GetImages: Task Cancelled")
                    return
                } catch {
                    state = EaseViewState(isLoading: false, error: error.localizedDescription)
                    Logger.error("GetImages: Unexpected error \(error)")
                    return
                }
            }
        }
    }
    
    func setCurrentDataList(_ data: [EaseItem]) {
        self.currentDataList = data
    }
    
    func onReAgainClicked(request: EaseCreateRequest) async {
        if (!isSecondItemShown) {
            state = EaseViewState(isLoading: false )
            isSecondItemShown = true
        } else {
            await fetchCreateImages(easeCreateRequest: request)
        }
    }
    
    func cancelFetchTask() {
        fetchTask?.cancel()
        errorTask?.cancel()
        errorTask = nil
        fetchTask = nil
        state = EaseViewState(progress: 0)
        
    }
    
    func cleanState () {
        state = EaseViewState(progress: 0)
    }
    
}


enum EaseStatus : String {
    case pending
    case error
}

struct EaseViewState {
    let isLoading: Bool
    let error: String?
    let data: [EaseItem]?
    let progress: Int
    
    init(isLoading: Bool = false, error: String? = nil, data: [EaseItem]? = nil, progress: Int = 0) {
        self.isLoading = isLoading
        self.error = error
        self.data = data
        self.progress = progress
    }
}

let KEY_CHECK_SAFE_PROMPT = true


extension TranslateNew {
    static func translateAsync(langFrom: String, langTo: String, text: String) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            translate(langFrom: langFrom, langTo: langTo, textToTranslate: text) { text in
                continuation.resume(returning: text)
            } translateError: { error in
                continuation.resume(throwing: error as! Error)
            }
        }
    }
}
