//
//  LanguageManager.swift
//  ImageAI
//
//  Created by DoanhMac on 20/3/25.
//

import Foundation
import FMDB

class LanguageManager {
    static var instance : LanguageManager? = nil
    
    static func getInstance() -> LanguageManager? {
        if instance == nil {
            instance = LanguageManager()
            return instance
        }
        return instance
    }
    
    
    private var database: FMDatabase? = nil
    
    init() {
       copyDatabaseIfNeeded(fileName: "lang.db")
       openDatabase()
   }
    
    func getListLanguageStart() async -> Result<[Language], Error> {
        var listResult = [Language]()
        
        let query = "SELECT * FROM langtrans WHERE app IS NOT NULL ORDER BY popular ASC;"
        
        do {
            guard let database = database else {
                return .failure(NSError(domain: "DatabaseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Database not opened"]))
            }

            let resultSet = try await Task.detached { try database.executeQuery(query, values: nil) }.value
            
            defer { resultSet.close() }

            while resultSet.next() {
                let langCode = resultSet.string(forColumn: "lang_code_new") ?? ""
                let languageAndCountry = langCode.split(separator: "_").map { String($0) }

                let langName: String
                if languageAndCountry.count > 1 {
                    langName = Locale(identifier: UserDefaults.standard.string(forKey: KEY_SELECTED_LANGUAGE_CODE) ?? "").localizedString(forIdentifier: languageAndCountry[0]) ?? "Unknown"
                } else {
                    langName = Locale(identifier: UserDefaults.standard.string(forKey: KEY_SELECTED_LANGUAGE_CODE) ?? "").localizedString(forIdentifier: langCode) ?? "Unknown"
                }

                let language = Language.Builder()
                    .setId(Int(resultSet.int(forColumn: "id")))
                    .setLangName(langName)
                    .setLangCode(langCode)
                    .setLangNameEnglish(resultSet.string(forColumn: "language_name") ?? "")
                    .setLangNameNative(resultSet.string(forColumn: "language_native") ?? "")
                    .setAppCode(resultSet.string(forColumn: "app") ?? "")
                    .setGoogleCode(resultSet.string(forColumn: "google") ?? "")
                    .setIsRight(resultSet.int(forColumn: "isRight") == 1)
                    .setOfflineCode(resultSet.string(forColumn: "offline") ?? "")
                    .setDeepCode(resultSet.string(forColumn: "deep") ?? "")
                    .setAmazonCode(resultSet.string(forColumn: "amazon") ?? "")
                    .setGeminiCode(resultSet.string(forColumn: "gemini") ?? "")
                    .setMicrosoftCode(resultSet.string(forColumn: "microsoft") ?? "")
                    .build()

                listResult.append(language)
            }

            return .success(listResult)
        } catch {
            return .failure(error)
        }
    }

    var databasePath: String {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("lang.db").path
    }
    
    
    func closeEncryptedDatabase() {
        database?.close()
        database = nil
        Logger.warning("🔒 Database close")
    }
    
    func openDatabase() {
        let fileManager = FileManager.default
        let docURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbPath = docURL.appendingPathComponent("lang.db").path
        
        guard fileManager.fileExists(atPath: dbPath) else {
            print("❌ Database file not found at path: \(dbPath)")
            return
        }
        database = FMDatabase(path: dbPath)
        if database!.open() {
            print("✅ Database opened successfully!")
        }
    }
    
    func copyDatabaseIfNeeded(fileName: String) {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationURL = documentDirectory.appendingPathComponent(fileName)

            if !FileManager.default.fileExists(atPath: destinationURL.path) {
                if let sourceURL = Bundle.main.url(forResource: fileName, withExtension: nil) {
                    do {
                        try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
                        Logger.warning("Database copied to Documents directory: \(destinationURL.path)")
                    } catch {
                        Logger.error("Error copying database: \(error.localizedDescription)")
                    }
                } else {
                    Logger.error("Database file not found in bundle.")
                }
            } else {
                Logger.error("Database file already exists at: \(destinationURL.path)")
            }
        }
}
