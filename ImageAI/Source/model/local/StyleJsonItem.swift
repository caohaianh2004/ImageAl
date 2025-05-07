//
//  StyleJsonItem.swift
//  ImageAI
//
//  Created by DoanhMac on 10/3/25.
//
import Foundation
import SwiftUI

class StyleJsonItem: Identifiable, Codable {
    var id: Int
    var avatar: String
    var prompt: String
    var style: String
    var style_lang_default: String
    var style_cls: String
    var example_prompt: String?
    
    init(id: Int, avatar: String, prompt: String, style: String, style_lang_default: String, style_cls: String, example_prompt: String?) {
        self.id = id
        self.avatar = avatar
        self.prompt = prompt
        self.style = style
        self.style_lang_default = style_lang_default
        self.style_cls = style_cls
        self.example_prompt = example_prompt
    }
    
}

class StyleJsonItemBuilder {
    private var id: Int
    private var avatar: String
    private var prompt: String
    private var style: String
    private var style_lang_default: String
    private var style_cls: String
    private var example_prompt: String?
    
  
    init() {
        self.id = 0
        self.avatar = ""
        self.prompt = ""
        self.style = ""
        self.style_lang_default = ""
        self.style_cls = ""
        self.example_prompt = nil
    }
    
   
    init(from item: StyleJsonItem) {
        self.id = item.id
        self.avatar = item.avatar
        self.prompt = item.prompt
        self.style = item.style
        self.style_lang_default = item.style_lang_default
        self.style_cls = item.style_cls
        self.example_prompt = item.example_prompt
    }
    
    func setId(_ id: Int) -> StyleJsonItemBuilder {
        self.id = id
        return self
    }
    
    func setAvatar(_ avatar: String) -> StyleJsonItemBuilder {
        self.avatar = avatar
        return self
    }
    
    func setPrompt(_ prompt: String) -> StyleJsonItemBuilder {
        self.prompt = prompt
        return self
    }
    
    func setStyle(_ style: String) -> StyleJsonItemBuilder {
        self.style = style
        return self
    }
    
    func setStyleLangDefault(_ styleLangDefault: String) -> StyleJsonItemBuilder {
        self.style_lang_default = styleLangDefault
        return self
    }
    
    func setStyleCls(_ styleCls: String) -> StyleJsonItemBuilder {
        self.style_cls = styleCls
        return self
    }
    
    func setExamplePrompt(_ examplePrompt: String?) -> StyleJsonItemBuilder {
        self.example_prompt = examplePrompt
        return self
    }
    
    func build() -> StyleJsonItem {
        return StyleJsonItem(
            id: id,
            avatar: avatar,
            prompt: prompt,
            style: style,
            style_lang_default: style_lang_default,
            style_cls: style_cls,
            example_prompt: example_prompt
        )
    }
}


struct StyleDataFromJson : Codable {
    let title: String
    let data: [StyleJsonItem]
}


extension StyleJsonItem {
    
    static func getListResource() -> [String: Quadruple] {
        return [
            "Photograph": Quadruple(
                title: NSLocalizedString("style_photo", comment: ""),
                nameRes: styleItemPhotographName,
                promptRes: styleItemPhotographPrompt,
                exampleRes: listPromptExample1
            ),
            "Art": Quadruple(
                title: NSLocalizedString("style_art", comment: ""),
                nameRes: artStyleNames,
                promptRes: artStylePrompts,
                exampleRes: listPromptExample2
            ),
            "Cartoon": Quadruple(
                title: NSLocalizedString("style_cartoon", comment: ""),
                nameRes: styleItemCartoonName,
                promptRes: styleItemCartoonPrompt,
                exampleRes: listPromptExample3
            ),
            "Game": Quadruple(
                title: NSLocalizedString("style_game", comment: ""),
                nameRes: styleItemGameName,
                promptRes: styleItemGamePrompt,
                exampleRes: listPromptExample4
            ),
            "Logo": Quadruple(
                title: NSLocalizedString("style_logo", comment: ""),
                nameRes: styleItemLogoName,
                promptRes: styleItemLogoPrompt,
                exampleRes: listPromptExample5
            ),
            "Tattoo": Quadruple(
                title: NSLocalizedString("style_tattoo", comment: ""),
                nameRes: styleItemTattooName,
                promptRes: styleItemTattooPrompt,
                exampleRes: listPromptExample6
            ),
            "Icon": Quadruple(
                title: NSLocalizedString("style_icon", comment: ""),
                nameRes: styleItemIconName,
                promptRes: styleItemIconPrompt,
                exampleRes: listPromptExample7
            ),
            "Text": Quadruple(
                title: NSLocalizedString("style_text", comment: ""),
                nameRes: styleItemTextName,
                promptRes: styleItemTextPrompt,
                exampleRes: listPromptExample8
            ),
            "Sticker": Quadruple(
                title: NSLocalizedString("style_sticker", comment: ""),
                nameRes: styleItemStickerName,
                promptRes: styleItemStickerPrompt,
                exampleRes: listPromptExample9
            )
        ]
    }
   
    
    static func getListStyleSeeAll() -> [DataStyle] {
        let listStyleJson = loadStyleJsonData()
        var styleFilterList: [DataStyle] = []
        listStyleJson.forEach { styleJsonItem in
            let styleData = DataStyle(title: styleJsonItem.style, styleId: styleJsonItem.id)
            styleFilterList.append(styleData)
        }
        return styleFilterList
    }

    static func getListStyleSeeAll(listStyleJson: [StyleJsonItem]) -> [DataStyle] {
        var styleFilterList: [DataStyle] = []
        listStyleJson.forEach { styleJsonItem in
            let styleData = DataStyle(title: styleJsonItem.style, styleId: styleJsonItem.id)
            styleFilterList.append(styleData)
        }
        return styleFilterList
    }

    
    static func getListStyleDetailsByStyleDefault(_ styleDefault:String) -> [StyleJsonItem] {
        let styleDataList = getListStyleJson()
        return styleDataList.first(where: { $0.title == styleDefault})?.data ?? []
    }
    
    static func getListStyleJson() -> [StyleDataFromJson] {
        var styleDataList: [StyleDataFromJson] = []
        let listStyleJson = loadStyleJsonData()
        let predefinedOrder = [
            "Photograph", "Art", "Cartoon", "Game", "Logo",
            "Tattoo", "Icon", "Text", "Sticker"
        ]
        let groupedStyleJson = Dictionary(grouping: listStyleJson, by: { $0.style_lang_default })
        

        let sortedGroupedStyleJson = groupedStyleJson.sorted {
            guard let index1 = predefinedOrder.firstIndex(of: $0.key),
                  let index2 = predefinedOrder.firstIndex(of: $1.key) else {
                return false
            }
            return index1 < index2
        }

        for (style, listStyleJson) in sortedGroupedStyleJson {
            guard let resource = StyleJsonItem.getListResource()[style] else { continue }
            
//            let title = resource.title
            let listName = resource.nameRes
            let listPrompt = resource.promptRes
            let listExample = resource.exampleRes

            let bodyItems = listStyleJson.enumerated().map { (index, styleJsonItem) in
                let prompt = listPrompt[index]
                _ = listName[index]
                let example = listExample[index]
                
                return StyleJsonItemBuilder(from: styleJsonItem)
//                    .setStyleCls(title)
                    .setPrompt(prompt)
                    .setExamplePrompt(example)
                    .build()
            }
            
            styleDataList.append(StyleDataFromJson(title: style, data: bodyItems))
        }
        
        return styleDataList
    }

    
    static func loadStyleJsonData() -> [StyleJsonItem] {
        guard let data = readDataFromAssets(fileName: "style_ai_new.json") else {
            return []
        }
        
        do {
            let decodedData = try JSONDecoder().decode([StyleJsonItem].self, from: data)
            return decodedData
        } catch {
            print("Error decoding JSON: \(error)")
            return []
        }
    }
    
    static func fake() -> [StyleJsonItem] {
        return [
            StyleJsonItem(
                id: 1,
                avatar: "https://example.com/avatar1.png",
                prompt: "Create a fantasy landscape",
                style: "Fantasy",
                style_lang_default: "en",
                style_cls: "fantasy_class",
                example_prompt: "A magical forest with glowing trees"
            ),
            StyleJsonItem(
                id: 2,
                avatar: "https://example.com/avatar2.png",
                prompt: "Draw a cyberpunk city",
                style: "Cyberpunk",
                style_lang_default: "en",
                style_cls: "cyberpunk_class",
                example_prompt: "A futuristic city with neon lights and flying cars"
            ),
            StyleJsonItem(
                id: 3,
                avatar: "https://example.com/avatar3.png",
                prompt: "Sketch a medieval castle",
                style: "Medieval",
                style_lang_default: "en",
                style_cls: "medieval_class",
                example_prompt: "A grand castle surrounded by a moat and towers"
            ),
            StyleJsonItem(
                id: 4,
                avatar: "https://example.com/avatar4.png",
                prompt: "Illustrate a sci-fi spaceship",
                style: "Sci-Fi",
                style_lang_default: "en",
                style_cls: "scifi_class",
                example_prompt: "A sleek spaceship traveling through a wormhole"
            ),
            StyleJsonItem(
                id: 5,
                avatar: "https://example.com/avatar5.png",
                prompt: "Paint a sunset over the ocean",
                style: "Realism",
                style_lang_default: "en",
                style_cls: "realism_class",
                example_prompt: "A peaceful ocean reflecting the warm colors of the sunset"
            )
        ]
    }
}









