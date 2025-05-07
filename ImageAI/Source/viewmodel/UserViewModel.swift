//
//  UserViewModel.swift
//  ImageAI
//
//  Created by DoanhMac on 21/3/25.
//

import Foundation

@MainActor
class UserViewModel : ObservableObject {
    private let userDatabase = UserDatabase.getInstance()
    @Published var userState = UserState()
    
    func fetchAllImages() async {
        userState = UserState(isLoading: true)
        let result = await userDatabase!.getAllImages()
        
        switch result {
        case .success(let users):
            let currentDate = Date()
            let calendar = Calendar.current
            var updatedUsers: [ImageUser] = []
            
            for user in users {
                if let userDate = DateFormatterManager.shared.parseDateTime(user.date),
                   let daysDifference = calendar.dateComponents([.day], from: userDate, to: currentDate).day {
                    
                    if daysDifference >= 7 {
                        await removeImage(id: user.id!)
                    } else {
                      
                        let updatedUser = ImageUser.Builder()
                            .setId(user.id)
                            .setPrompt(user.prompt)
                            .setDate(user.date)
                            .setStyleId(user.styleId)
                            .setImageUrl(user.imageUrl)
                            .setSizeCanvas(user.sizeCanvas)
                            .setType(user.type)
                            .setCurrentDay(String(7 - daysDifference))
                            .build()
                        
                        updatedUsers.append(updatedUser)
                    }
                }
            }
            
            userState = UserState(users: updatedUsers.reversed())
            
        case .failure(let error):
            userState = UserState(error: error.localizedDescription)
        }
    }


    
    func addImage(_ imageUser: ImageUser) async {
        let result = await userDatabase!.insertImage(imageUser: imageUser)
        switch result {
        case .success:
            Logger.success("Add success")
            DispatchQueue.main.async {
                self.userState = UserState(
                    users: self.userState.users + [imageUser]
                )
            }
        case .failure(let error):
            userState = UserState(error: error.localizedDescription)
        }
    }
    
    func removeImage(id: Int) async  {
    
            let result = await userDatabase!.deleteImage(id: id)
            switch result {
            case .success:
                Logger.success("Delete success")
                DispatchQueue.main.async {
                    self.userState = UserState(
                        users: self.userState.users.filter { $0.id != id }
                    )
                }
            case .failure(let error):
                userState = UserState(error: error.localizedDescription)
            }
    
        
    }
    
    func daysPassedSince(_ dateString: String) -> Int? {
        guard let pastDate = DateFormatterManager.shared.parseDateTime(dateString) else {
            return nil
        }
        let currentDate = Date()
        let calendar = Calendar.current
        return calendar.dateComponents([.day], from: pastDate, to: currentDate).day
    }

    
}

struct UserState {
    let isLoading: Bool
    let error: String?
    let users: [ImageUser]
    
    init(isLoading: Bool = false, error: String? = nil, users: [ImageUser] = []) {
        self.isLoading = isLoading
        self.error = error
        self.users = users
    }
}
class DateFormatterManager {
    static let shared = DateFormatterManager()
    
    private let dateFormatter: DateFormatter
    
    private init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
    }
    
    func parseDateTime(_ dateString: String) -> Date? {
        return dateFormatter.date(from: dateString)
    }
    
    func formatDateTime(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}
