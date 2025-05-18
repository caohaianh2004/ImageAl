//
//  EnhanceRestoreViewModel.swift
//  ImageAI
//
//  Created by DoanhMac on 18/3/25.
//

import SwiftUI
import Foundation

@MainActor
public class EnhanceRestoreViewModel: ObservableObject {
    private let repository: AppRepositoryProtocol
    private var fetchTask: Task<Void, Never>?
    private var isSecondItemShown: Bool = false

    @Published private(set) var state: EaseViewState = EaseViewState()
    
    init(repository: AppRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchCreateImages(origin: UIImage, swapFaces: [UIImage]) async {
        state = EaseViewState(isLoading: true)
        
        let originBase64Str = await Base64Image.base64EncodeImage(origin)
        Logger.success("\(swapFaces.count)")
        
        var swapBase64List: [String] = []
        for face in swapFaces {
            let base64 = await Base64Image.base64EncodeImage(face)
            swapBase64List.append(base64)
        }

        let newRequest = MultiSFace(original: originBase64Str, images: swapBase64List)
        let result = await repository.createMuliFace(multifaceRequest: newRequest)

        switch result {
        case .success(let data):
            Logger.success("Start create image with sessionId: \(data.sessionId)")
            getImageData(taskId: data.sessionId)
        case .failure(let error):
            self.state = EaseViewState(error: error.localizedDescription)
        }
    }



    func fetchCreateImages(originalImage: UIImage, faceImage: UIImage) async {
        state = EaseViewState(isLoading: true)
        
        async let originalBase64 = Base64Image.base64EncodeImage(originalImage)
        async let faceBase64 = Base64Image.base64EncodeImage(faceImage)

        let (originalBase64Str, faceBase64Str) = await (originalBase64, faceBase64)
        
        let newRequest = SwapFace(originals: [originalBase64Str], faces: [faceBase64Str])
        Logger.success("\(newRequest)")
        let result = await repository.createSwapFace(swapfaceRequest: newRequest)
        
        switch result {
        case .success(let data):
            Logger.success("Start create image: \(data.sessionId)")
            getImageData(taskId: data.sessionId)
        case .failure(let error):
            self.state = EaseViewState(error: error.localizedDescription)
        }
    }
    
    func fetchCreateImages(facecropCreateRequest: FaceCrop, uiImage: UIImage) async {
        state = EaseViewState(isLoading: true)
        let base64Str = await Base64Image.base64EncodeImage(uiImage)
        
        let newRequest = FaceCrop(images: [base64Str])
        Logger.success("\(newRequest)")
        let result = await repository.createFaceCrop(facecropRequest: newRequest)
        
        switch result {
        case .success(let data):
            Logger.success("Start create image: \(data.sessionId)")
            getImageData(taskId: data.sessionId)
        case .failure(let error):
            self.state = EaseViewState(error: error.localizedDescription)
        }
    }
    
    func fetchCreateImages(headshotCreateRequest:HeadShort, uiImage: UIImage) async {
        state = EaseViewState(isLoading: true)
        let base64Str = await Base64Image.base64EncodeImage(uiImage)
        
        let newRequest = HeadShort(size: headshotCreateRequest.size, style: headshotCreateRequest.style, images: [base64Str])
        Logger.success("\(newRequest)")
        let result = await repository.createHeadShort(headShortRequest: newRequest)
        
        switch result {
        case .success(let data):
            Logger.success("Start create image: \(data.sessionId)")
            getImageData(taskId: data.sessionId)
        case .failure(let error):
            self.state = EaseViewState(error: error.localizedDescription)
        
        }
    }
    
    func fetchCreateImages(enhanceCreateRequest:EnhanceCreateRequest, uiImage: UIImage) async {
        state = EaseViewState(isLoading: true)
        let base64Str = await Base64Image.base64EncodeImage(uiImage)
        
        let newRequest = EnhanceCreateRequest(mode: enhanceCreateRequest.mode, size: enhanceCreateRequest.size, images: [base64Str])
        Logger.success("\(newRequest)")
        let result = await repository.createEnhanceSession(enhanceCreateRequest: newRequest)
        
        switch result {
        case .success(let data):
            Logger.success("Start create image \(data.sessionId)")
            getImageData(taskId: data.sessionId)
        case .failure(let error):
            self.state = EaseViewState(error: error.localizedDescription)
            
        }
    }
    
    func fetchCreateImages(restoreCreateRequest:RestoreCreateRequest, uiImage: UIImage) async {
        state = EaseViewState(isLoading: true)
        let base64Str = await Base64Image.base64EncodeImage(uiImage)
        
        let newRequest = RestoreCreateRequest(restore_type: restoreCreateRequest.restore_type, images: [base64Str])
        Logger.success("\(newRequest)")
        let result = await repository.createRestoreSession(restoreCreateRequest: newRequest)
        
        switch result {
        case .success(let data):
            Logger.success("Start create image \(data.sessionId)")
            getImageData(taskId: data.sessionId)
        case .failure(let error):
            self.state = EaseViewState(error: error.localizedDescription)
            
        }
    }


    func getImageData(taskId: String) {
        fetchTask?.cancel()
        fetchTask = Task {
            var progress = 1
            
            while !Task.isCancelled {
                do {
                    let result = await repository.getTaskEnhance(enhanceTaskRequest: EnhanceTaskRequest(processId: taskId))
                    
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
                       
                        let dataResult =  try JSONDecoder().decode(EaseTaskResponse.self, from: data)
                        Logger.success("getImages Success: \(String(describing: dataResult.data.first))")
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

    
    func cancelFetchTask() {
        fetchTask?.cancel()
        fetchTask = nil
        state = EaseViewState(progress: 0)
        
    }
    
    func cleanState () {
        state = EaseViewState(progress: 0)
    }
    
}

