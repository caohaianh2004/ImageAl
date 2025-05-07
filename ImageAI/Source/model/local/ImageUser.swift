//
//  ImageUser.swift
//  ImageAI
//
//  Created by DoanhMac on 21/3/25.
//
import Foundation


class ImageUser {
    let id: Int?
    let prompt: String
    let date: String
    let styleId: Int
    let imageUrl: String
    let sizeCanvas: String
    let type: Int
    let currentDay:String

    
    private init(builder: Builder) {
        self.id = builder.id
        self.prompt = builder.prompt
        self.date = builder.date
        self.styleId = builder.styleId
        self.imageUrl = builder.imageUrl
        self.sizeCanvas = builder.sizeCanvas
        self.type = builder.type
        self.currentDay = builder.currentDay
    }
    
    class Builder {
        var id: Int?
        var prompt: String = ""
        var date: String = ""
        var styleId: Int = 0
        var imageUrl: String = ""
        var sizeCanvas: String = ""
        var type: Int = 0
        var currentDay:String = ""
        
        func setId(_ id: Int?) -> Builder {
            self.id = id
            return self
        }
        
        func setPrompt(_ prompt: String) -> Builder {
            self.prompt = prompt
            return self
        }
        
        func setDate(_ date: String) -> Builder {
            self.date = date
            return self
        }
        
        func setStyleId(_ styleId: Int) -> Builder {
            self.styleId = styleId
            return self
        }
        
        func setImageUrl(_ imageUrl: String) -> Builder {
            self.imageUrl = imageUrl
            return self
        }
        
        func setSizeCanvas(_ sizeCanvas: String) -> Builder {
            self.sizeCanvas = sizeCanvas
            return self
        }
        
        func setType(_ type: Int) -> Builder {
            self.type = type
            return self
        }
        func setCurrentDay(_ currentDay:String) -> Builder {
            self.currentDay = currentDay
            return self
        }
        
        
        func build() -> ImageUser {
            return ImageUser(builder: self)
        }
    }
}
