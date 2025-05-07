//
//  Language.swift
//  ImageAI
//
//  Created by DoanhMac on 20/3/25.
//

import Foundation

import Foundation

class Language: NSObject, Codable, NSCoding {
    var id: Int
    var langNameEnglish: String
    var langName: String
    var langCode: String
    var langNameNative: String
    var appCode: String
    var googleCode: String
    var isRight: Bool
    var offlineCode: String
    var deepCode: String
    var amazonCode: String
    var geminiCode: String
    var microsoftCode: String

    // Singleton for current language settings
    static var currentLang: Language?
    static var currentLangDisplay: Language?


    private init(builder: Builder) {
        self.id = builder.id
        self.langNameEnglish = builder.langNameEnglish
        self.langName = builder.langName
        self.langCode = builder.langCode
        self.langNameNative = builder.langNameNative
        self.appCode = builder.appCode
        self.googleCode = builder.googleCode
        self.isRight = builder.isRight
        self.offlineCode = builder.offlineCode
        self.deepCode = builder.deepCode
        self.amazonCode = builder.amazonCode
        self.geminiCode = builder.geminiCode
        self.microsoftCode = builder.microsoftCode
    }

    required init?(coder: NSCoder) {
        self.id = coder.decodeInteger(forKey: "id")
        self.langNameEnglish = coder.decodeObject(forKey: "langNameEnglish") as? String ?? ""
        self.langName = coder.decodeObject(forKey: "langName") as? String ?? ""
        self.langCode = coder.decodeObject(forKey: "langCode") as? String ?? ""
        self.langNameNative = coder.decodeObject(forKey: "langNameNative") as? String ?? ""
        self.appCode = coder.decodeObject(forKey: "appCode") as? String ?? ""
        self.googleCode = coder.decodeObject(forKey: "googleCode") as? String ?? ""
        self.isRight = coder.decodeBool(forKey: "isRight")
        self.offlineCode = coder.decodeObject(forKey: "offlineCode") as? String ?? ""
        self.deepCode = coder.decodeObject(forKey: "deepCode") as? String ?? ""
        self.amazonCode = coder.decodeObject(forKey: "amazonCode") as? String ?? ""
        self.geminiCode = coder.decodeObject(forKey: "geminiCode") as? String ?? ""
        self.microsoftCode = coder.decodeObject(forKey: "microsoftCode") as? String ?? ""
    }

    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(langNameEnglish, forKey: "langNameEnglish")
        coder.encode(langName, forKey: "langName")
        coder.encode(langCode, forKey: "langCode")
        coder.encode(langNameNative, forKey: "langNameNative")
        coder.encode(appCode, forKey: "appCode")
        coder.encode(googleCode, forKey: "googleCode")
        coder.encode(isRight, forKey: "isRight")
        coder.encode(offlineCode, forKey: "offlineCode")
        coder.encode(deepCode, forKey: "deepCode")
        coder.encode(amazonCode, forKey: "amazonCode")
        coder.encode(geminiCode, forKey: "geminiCode")
        coder.encode(microsoftCode, forKey: "microsoftCode")
    }

    func getLocaleDisplayName() -> String {
        let components = langCode.split(separator: "-")
        if components.count > 1 {
            let locale = Locale(identifier: "\(components[0])_\(components[1])")
            return locale.localizedString(forLanguageCode: String(components[0])) ?? langName
        } else {
            return Locale(identifier: langCode).localizedString(forLanguageCode: langCode) ?? langName
        }
    }

    class Builder {
        var id: Int = 0
        var langNameEnglish: String = ""
        var langName: String = ""
        var langCode: String = ""
        var langNameNative: String = ""
        var appCode: String = ""
        var googleCode: String = ""
        var isRight: Bool = false
        var offlineCode: String = ""
        var deepCode: String = ""
        var amazonCode: String = ""
        var geminiCode: String = ""
        var microsoftCode: String = ""

        func setId(_ id: Int) -> Builder {
            self.id = id
            return self
        }

        func setLangNameEnglish(_ langNameEnglish: String) -> Builder {
            self.langNameEnglish = langNameEnglish
            return self
        }

        func setLangName(_ langName: String) -> Builder {
            self.langName = langName
            return self
        }

        func setLangCode(_ langCode: String) -> Builder {
            self.langCode = langCode
            return self
        }

        func setLangNameNative(_ langNameNative: String) -> Builder {
            self.langNameNative = langNameNative
            return self
        }

        func setAppCode(_ appCode: String) -> Builder {
            self.appCode = appCode
            return self
        }

        func setGoogleCode(_ googleCode: String) -> Builder {
            self.googleCode = googleCode
            return self
        }

        func setIsRight(_ isRight: Bool) -> Builder {
            self.isRight = isRight
            return self
        }

        func setOfflineCode(_ offlineCode: String) -> Builder {
            self.offlineCode = offlineCode
            return self
        }

        func setDeepCode(_ deepCode: String) -> Builder {
            self.deepCode = deepCode
            return self
        }

        func setAmazonCode(_ amazonCode: String) -> Builder {
            self.amazonCode = amazonCode
            return self
        }

        func setGeminiCode(_ geminiCode: String) -> Builder {
            self.geminiCode = geminiCode
            return self
        }

        func setMicrosoftCode(_ microsoftCode: String) -> Builder {
            self.microsoftCode = microsoftCode
            return self
        }

        func build() -> Language {
            return Language(builder: self)
        }
    }
}
