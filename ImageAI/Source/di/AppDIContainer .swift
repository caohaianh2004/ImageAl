//
//  AppDIContainer .swift
//  ImageAI
//
//  Created by DoanhMac on 13/3/25.
//
import Foundation
import SwiftUI

class AppDIContainer {
    static let shared = AppDIContainer()
    private init() {}

    private lazy var networkManager: URLSessionManager = {
        return .shared
    }()

    lazy var appRepository: AppRepositoryProtocol = {  
        return AppRepository(networkManager: networkManager)
    }()
    
    @MainActor
    func makeEaseViewModel() -> EaseViewModel {
        return EaseViewModel(repository: appRepository)
    }
    @MainActor
    func makeQwenViewModel() -> QwenViewModel {
        return QwenViewModel(repository: appRepository)
    }
    @MainActor
    func makeEnhanceRestoreViewModel() -> EnhanceRestoreViewModel {
        return EnhanceRestoreViewModel(repository: appRepository)
    }
    @MainActor
    func makeImageUserModel() -> UserViewModel {
        return UserViewModel()
    }
}
