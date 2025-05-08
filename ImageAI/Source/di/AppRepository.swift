//
//  AppRepository.swift
//  ImageAI
//
//  Created by DoanhMac on 13/3/25.
//

import Foundation
import SwiftUI

protocol AppRepositoryProtocol {
    //Text To Image
    func createImageEase(easeCreateRequest: EaseCreateRequest) async -> Result<EaseCreateResponse, Error>
    func getTaskEase(easeTaskRequest:EaseTaskRequest) async -> Result<Data, Error>
    //Image To Image
    func createNewIdQwen() async -> Result<QwenResponseNewId, Error>
    func getTaskQwen(qwenTaskRequest:QwenRequest) async -> Result<QwenResponse, Error>
    //Enhance
    func createEnhanceSession(enhanceCreateRequest:EnhanceCreateRequest) async -> Result<EnhanceCreateResponse, Error>
    func getTaskEnhance(enhanceTaskRequest:EnhanceTaskRequest) async -> Result<Data, Error>
    //Restore
    func createRestoreSession(restoreCreateRequest:RestoreCreateRequest) async -> Result<EnhanceCreateResponse, Error>
    //GenerateHeadshot 
    func createHeadShort(headShortRequest: HeadShort) async -> Result<EnhanceCreateResponse, Error>
    //Swap Face
    func createSwapFace(swapfaceRequest: SwapFace) async -> Result<EnhanceCreateResponse, Error>
    //Multi Face
    func createMuliFace(multifaceRequest: MultiSFace) async -> Result<EnhanceCreateResponse, Error>
}

class AppRepository: AppRepositoryProtocol {
    
    private let networkManager: URLSessionManager
    
    init(networkManager: URLSessionManager = .shared) {
        self.networkManager = networkManager
    }
    
    func createImageEase(easeCreateRequest: EaseCreateRequest) async -> Result<EaseCreateResponse, Error> {
        do {
            let data = try await networkManager.requestNewApi(endpoint: .createImageEase, body: easeCreateRequest)
            //                if let jsonString = String(data: data, encoding: .utf8) {
            //                    Logger.success("📩 API Response: \(jsonString)")
            //                   }
            let decodedData = try JSONDecoder().decode(EaseCreateResponse.self, from: data)
            //                let decodedData = try JSONDecoder().decode(EaseTaskResponse.self, from: data)
            return .success(decodedData)
        } catch {
            return .failure(error)
        }
    }
    
    func getTaskEase(easeTaskRequest: EaseTaskRequest) async -> Result<Data, Error> {
        do {
            let data = try await networkManager.requestNewApi(endpoint: .getTaskEase, body: easeTaskRequest)
            //
            //             if let jsonString = String(data: data, encoding: .utf8) {
            //                 Logger.success("📩 API Response: \(data)")
            //
            //             }
            return .success(data)
            
        } catch {
            return .failure(error)
        }
    }
    
    func createNewIdQwen() async -> Result<QwenResponseNewId, Error> {
        do {
            let data: Data = try await networkManager.requestOldApi(endpoint: .createQwenId)
            let response = try JSONDecoder().decode(QwenResponseNewId.self, from: data)
            
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
    
    func getTaskQwen(qwenTaskRequest: QwenRequest) async -> Result<QwenResponse,  Error> {
        do {
            let data : Data = try await networkManager.requestOldApi(endpoint: .getTaskQwen, body: qwenTaskRequest)
            let response: QwenResponse = try JSONDecoder().decode(QwenResponse.self, from: data)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
    
    func createEnhanceSession(enhanceCreateRequest: EnhanceCreateRequest) async -> Result<EnhanceCreateResponse, any Error> {
        do {
            let data = try await networkManager.requestNewApi(endpoint: .createEnhanceSession, body: enhanceCreateRequest)
            let decodedData = try JSONDecoder().decode(EnhanceCreateResponse.self, from: data)
            return .success(decodedData)
        } catch {
            return .failure(error)
        }
    }
    
    func getTaskEnhance(enhanceTaskRequest: EnhanceTaskRequest) async -> Result<Data, any Error> {
        do {
            let data = try await networkManager.requestNewApi(endpoint: .getTaskEnhance, body: enhanceTaskRequest)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
    
    func createRestoreSession(restoreCreateRequest: RestoreCreateRequest) async -> Result<EnhanceCreateResponse, any Error> {
        do {
            let data = try await networkManager.requestNewApi(endpoint: .creaeteRestore, body: restoreCreateRequest)
            let decodedData = try JSONDecoder().decode(EnhanceCreateResponse.self, from: data)
            return .success(decodedData)
        } catch {
            return .failure(error)
        }
    }
    
    func createHeadShort(headShortRequest : HeadShort) async -> Result<EnhanceCreateResponse, any Error> {
        do {
            let data = try await networkManager.requestNewApi(endpoint: .headshort, body: headShortRequest)
            let decodeData = try JSONDecoder().decode(EnhanceCreateResponse.self, from: data)
            return .success(decodeData)
        } catch {
            return .failure(error)
        }
    }
    
    func createSwapFace(swapfaceRequest: SwapFace) async -> Result<EnhanceCreateResponse, any Error> {
        do {
            let data = try await networkManager.requestNewApi(endpoint: .swapface, body: swapfaceRequest)
            let decodeData = try JSONDecoder().decode(EnhanceCreateResponse.self, from: data)
            return .success(decodeData)
        } catch {
            return .failure(error)
        }
    }
    
    func createMuliFace(multifaceRequest: MultiSFace) async -> Result<EnhanceCreateResponse, Error> {
        do {
            let data = try await networkManager.requestNewApi(endpoint: .multiface, body: multifaceRequest)
            let decodeData = try JSONDecoder().decode(EnhanceCreateResponse.self, from: data)
            return .success(decodeData)
        } catch {
            return .failure(error)
        }
    }
}
