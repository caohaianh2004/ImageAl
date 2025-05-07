//
//  LanguageViewModel.swift
//  ImageAI
//
//  Created by DoanhMac on 20/3/25.
//

import Foundation
import SwiftUI

import SwiftUI

@MainActor
class LanguageViewModel: ObservableObject {
    private let databaseManager = LanguageManager.getInstance()
    
    @Published var state: LanguageState
    
    init() {
        let savedLanguage = UserDefaults.standard.string(forKey: KEY_SELECTED_LANGUAGE_CODE) ?? ""
        self.state = LanguageState(selectedLanguageCode: savedLanguage)
    }

    var isRTL: Bool {
        if #available(iOS 16.0, *) {
            return Locale.Language(identifier: state.selectedLanguageCode).characterDirection == .rightToLeft
        } else {
            return Locale.characterDirection(forLanguage: state.selectedLanguageCode) == .rightToLeft
        }
    }

    func fetchLanguages() {
        Task {
            
            guard let databaseManager = databaseManager else { return }
            self.state = LanguageState(isLoading: true, selectedLanguageCode: self.state.selectedLanguageCode)
            let result = await databaseManager.getListLanguageStart()
            switch result {
            case .success(let languages):
                let selectedLanguage = languages.first { $0.langCode == self.state.selectedLanguageCode }
                
                self.state = LanguageState(languages: languages, selectedLanguage: selectedLanguage, selectedLanguageCode: self.state.selectedLanguageCode)
            case .failure(let error):
                self.state = LanguageState(isLoading: false, selectedLanguageCode: self.state.selectedLanguageCode, error: error.localizedDescription)
            }
            
            
            
        }
    }

    func setSelectedLanguage(_ languageCode: String) {
        DispatchQueue.main.async {
            self.state = LanguageState(
                languages: self.state.languages,
                selectedLanguage: self.state.languages.first { $0.langCode == languageCode },
                selectedLanguageCode: languageCode
            )
        }
    
    }
    
    func doneSelectedLanguage(_ languageCode: String) {
        var langChange : String
        switch languageCode {
        case "en-GB":
            langChange = "en"
        case "en-US":
            langChange = "en"
        case "zh-CN":
            langChange = "zh"
        default:
            langChange = languageCode
        }
        LocalizationSystem.sharedInstance.setLanguage(languageCode: langChange)
        UserDefaults.standard.set(languageCode, forKey: KEY_SELECTED_LANGUAGE_CODE)
        UserDefaults.standard.synchronize()
      
        
    }

}


struct LanguageState {
    let isLoading: Bool
    let languages: [Language]
    let selectedLanguage: Language?
    let selectedLanguageCode: String
    let error: String
    
    init(
        isLoading: Bool = false,
        languages: [Language] = [],
        selectedLanguage: Language? = nil,
        selectedLanguageCode: String = "en",
        error: String = ""
    ) {
        self.languages = languages
        self.selectedLanguage = selectedLanguage
        self.selectedLanguageCode = selectedLanguageCode
        self.isLoading = isLoading
        self.error = error
    }
}

let KEY_SELECTED_LANGUAGE_CODE: String = "SelectedLanguageCode"

