//
//  UserDatabase.swift
//  ImageAI
//
//  Created by DoanhMac on 21/3/25.
//
import Foundation
import FMDB

class UserDatabase {
    static var instance : UserDatabase? = nil
    
    static func getInstance() -> UserDatabase? {
        if instance == nil {
            instance = UserDatabase()
            return instance
        }
        return instance
    }
    
    
    private var database: FMDatabase? = nil
    
    init() {
       copyDatabaseIfNeeded(fileName: "db_image_ai_new.db")
       openDatabase()
   }
    
    var databasePath: String {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("db_image_ai_new.db").path
    }
    
    
    func closeEncryptedDatabase() {
        database?.close()
        database = nil
        Logger.warning("🔒 Database close")
    }
    
    func openDatabase() {
        let fileManager = FileManager.default
        let docURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbPath = docURL.appendingPathComponent("db_image_ai_new.db").path
        
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
    
    func getAllImages() async -> Result<[ImageUser], Error> {
            return await withCheckedContinuation { continuation in
                var images: [ImageUser] = []
                let query = "SELECT * FROM image_user"
                
              
                
                do {
                    let results = try database?.executeQuery(query, values: nil)
                    while results?.next() == true {
                        let image = ImageUser.Builder()
                            .setId(Int(results?.int(forColumn: "id") ?? 0))
                            .setPrompt(results?.string(forColumn: "prompt") ?? "")
                            .setDate(results?.string(forColumn: "create_at") ?? "")
                            .setStyleId(Int(results?.int(forColumn: "style_id") ?? 0))
                            .setImageUrl(results?.string(forColumn: "image_url") ?? "")
                            .setSizeCanvas(results?.string(forColumn: "canvas") ?? "")
                            .setType(Int(results?.int(forColumn: "type") ?? 0))
                            .build()
                        images.append(image)
                    }
                    continuation.resume(returning: .success(images))
                } catch {
                    continuation.resume(returning: .failure(error))
                }
            }
        }
        
        func insertImage(imageUser: ImageUser) async -> Result<Void, Error> {
            return await withCheckedContinuation { continuation in
                let query = """
                INSERT INTO image_user(prompt, create_at, style_id, image_url, canvas, type)
                VALUES (?, ?, ?, ?, ?, ?)
                """
                do {
                    try database?.executeUpdate(query, values: [
                        imageUser.prompt,
                        imageUser.date,
                        imageUser.styleId,
                        imageUser.imageUrl,
                        imageUser.sizeCanvas,
                        imageUser.type
                    ])
                    continuation.resume(returning: .success(()))
                } catch {
                    continuation.resume(returning: .failure(error))
                }
            }
        }
        
        func deleteImage(id: Int) async -> Result<Void, Error> {
            return await withCheckedContinuation { continuation in
                let query = "DELETE FROM image_user WHERE id = ?"

                do {
                    try database?.executeUpdate(query, values: [id])
                    continuation.resume(returning: .success(()))
                } catch {
                    continuation.resume(returning: .failure(error))
                }
            }
        }


}

