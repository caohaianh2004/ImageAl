//
//  DataFromString.swift
//  ImageAI
//
//  Created by DoanhMac on 12/3/25.
//
import Foundation
import SwiftUI
import UIKit

let LINK_SERVER = "https://new-rest.onewise.app/"
func getOptimalImageSize(isExample: Bool = false) -> Int {
    let scale = UIScreen.main.scale
    let densityDpi = scale * 160  

    switch densityDpi {
    case ..<160: return 128
    case ..<240: return 256
    case ..<320: return 512
    case ..<480: return 512
    case ..<640: return isExample ? 1024 : 512
    default: return 512
    }
}

typealias Quadruple = (title: String, nameRes: [String], promptRes: [String], exampleRes: [String])

func readDataFromAssets(fileName: String) -> Data? {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
        Logger.error("Not found file \(fileName).json")
        return nil
    }
    return try? Data(contentsOf: url)
}

let listInspired : [String] = [
   "prompt1", 
   "prompt2", 
   "prompt3", 
   "prompt4", 
   "prompt5", 
   "prompt6", 
   "prompt7", 
   "prompt8", 
   "prompt9", 
   "prompt10", 
   "prompt11", 
   "prompt12", 
   "prompt13", 
   "prompt14", 
   "prompt15", 
]
let styleItemPhotographName: [String] = [
   "photo_name_no_style", 
   "photo_name_bokeh", 
   "photo_name_food", 
   "photo_name_iphone", 
   "photo_name_noir", 
]

let styleItemPhotographPrompt: [String] = [
   "photo_prompt_simple", 
   "photo_prompt_bokeh", 
   "photo_prompt_food", 
   "photo_prompt_iphone", 
   "photo_prompt_noir", 
]

let artStyleNames: [String] = [
   "art_name_cubist", 
   "art_name_pixel", 
   "art_name_dark_fantasy", 
   "art_name_van_gogh", 
   "art_name_caricature", 
   "art_name_statue", 
   "art_name_watercolor", 
   "art_name_oil_painting", 
   "art_name_pattern", 
   "art_name_painting", 
   "art_name_lego_character", 
   "art_name_doodle", 
   "art_name_fantasy", 
   "art_name_concept", 
   "art_name_lego_blocks", 
   "art_name_barbie_world", 
   "art_name_cyberpunk", 
   "art_name_pop", 
   "art_name_steampunk", 
   "art_name_cubism", 
]

let artStylePrompts: [String] = [
   "art_prompt_cubist", 
   "art_prompt_pixel", 
   "art_prompt_dark_fantasy", 
   "art_prompt_van_gogh", 
   "art_prompt_caricature", 
   "art_prompt_statue", 
   "art_prompt_watercolor", 
   "art_prompt_oil_painting", 
   "art_prompt_pattern", 
   "art_prompt_painting", 
   "art_prompt_lego_character", 
   "art_prompt_doodle", 
   "art_prompt_fantasy", 
   "art_prompt_concept", 
   "art_prompt_lego_blocks", 
   "art_prompt_barbie_world", 
   "art_prompt_cyberpunk", 
   "art_prompt_pop", 
   "art_prompt_steampunk", 
   "art_prompt_cubism", 
]

let styleItemCartoonName: [String] = [
   "cartoon_name_manga", 
   "cartoon_name_sketch", 
   "cartoon_name_comic", 
   "cartoon_name_kawaii", 
   "cartoon_name_chibi", 
   "cartoon_name_disney", 
   "cartoon_name_pixar", 
   "cartoon_name_funko_pop", 
   "cartoon_name_furry_art", 
   "cartoon_name_shrek", 
   "cartoon_name_barbie_doll", 
   "cartoon_name_bratz_doll", 
]

let styleItemCartoonPrompt: [String] = [
   "cartoon_prompt_manga", 
   "cartoon_prompt_sketch", 
   "cartoon_prompt_comic", 
   "cartoon_prompt_kawaii", 
   "cartoon_prompt_chibi", 
   "cartoon_prompt_disney", 
   "cartoon_prompt_pixar", 
   "cartoon_prompt_funko_pop", 
   "cartoon_prompt_furry_art", 
   "cartoon_prompt_shrek", 
   "cartoon_prompt_barbie_doll", 
   "cartoon_prompt_bratz_doll", 
]

let styleItemGameName: [String] = [
   "game_name_bubble_bobble", 
   "game_name_retro_arcade", 
   "game_name_minecraft", 
   "game_name_gta", 
   "game_name_pokemon", 
   "game_name_dnd", 
   "game_name_fortnite", 
]

let styleItemGamePrompt: [String] = [
   "game_prompt_bubble_bobble", 
   "game_prompt_retro_arcade", 
   "game_prompt_minecraft", 
   "game_prompt_gta", 
   "game_prompt_pokemon", 
   "game_prompt_dnd", 
   "game_prompt_fortnite", 
]

let styleItemLogoName: [String] = [
   "logo_3d", 
   "logo_minimalist", 
   "logo_cartoon", 
   "logo_energetic", 
   "logo_cute", 
   "logo_graffiti", 
]

let styleItemLogoPrompt: [String] = [
   "logo_prompt_3d", 
   "logo_prompt_minimalist", 
   "logo_prompt_cartoon", 
   "logo_prompt_energetic", 
   "logo_prompt_cute", 
   "logo_prompt_graffiti", 
]

let styleItemTattooName: [String] = [
   "tattoo_default", 
   "tattoo_line_art", 
   "tattoo_mandala", 
]

let styleItemTattooPrompt: [String] = [
   "tattoo_prompt_default", 
   "tattoo_prompt_line_art", 
   "tattoo_prompt_mandala", 
]

let styleItemIconName: [String] = [
   "icon_name_2d", 
   "icon_name_3d", 
]

let styleItemIconPrompt: [String] = [
   "icon_prompt_2d", 
   "icon_prompt_3d", 
]

let styleItemTextName: [String] = [
   "text_name_plush", 
   "text_name_graffiti", 
   "text_name_hand_drawn", 
   "text_name_balloon", 
]

let styleItemTextPrompt: [String] = [
   "text_prompt_plush", 
   "text_prompt_graffiti", 
   "text_prompt_hand_drawn", 
   "text_prompt_balloon", 
]

let styleItemStickerName: [String] = [
   "sticker_name_illustration", 
   "sticker_name_sketch", 
   "sticker_name_colorful", 
   "sticker_name_cartoon", 
   "sticker_name_kawaii", 
   "sticker_name_q_version", 
]

let styleItemStickerPrompt: [String] = [
   "sticker_prompt_illustration", 
   "sticker_prompt_sketch", 
   "sticker_prompt_colorful", 
   "sticker_prompt_cartoon", 
   "sticker_prompt_kawaii", 
   "sticker_prompt_q_version", 
]


let listPromptExample1: [String] = [
   "promt_example_1", 
   "promt_example_2", 
   "promt_example_3", 
   "promt_example_4", 
   "promt_example_5", 
]

let listPromptExample2: [String] = [
   "promt_example_6", 
   "promt_example_7", 
   "promt_example_8", 
   "promt_example_9", 
   "promt_example_10", 
   "promt_example_11", 
   "promt_example_12", 
   "promt_example_13", 
   "promt_example_50", 
   "promt_example_51", 
   "promt_example_52", 
   "promt_example_54", 
   "promt_example_55", 
   "promt_example_56", 
   "promt_example_53", 
   "promt_example_61", 
   "promt_example_62", 
   "promt_example_64", 
   "promt_example_65", 
   "promt_example_66", 
]

let listPromptExample3: [String] = [
   "promt_example_14", 
   "promt_example_15", 
   "promt_example_16", 
   "promt_example_17", 
   "promt_example_18", 
   "promt_example_19", 
   "promt_example_20", 
   "promt_example_21", 
   "promt_example_49", 
   "promt_example_58", 
   "promt_example_60", 
   "promt_example_63", 
]

let listPromptExample4: [String] = [
   "promt_example_22", 
   "promt_example_23", 
   "promt_example_24", 
   "promt_example_25", 
   "promt_example_26", 
   "promt_example_47", 
   "promt_example_59", 
]


 let listPromptExample5: [String] = [
   "promt_example_27", 
   "promt_example_28", 
   "promt_example_29", 
   "promt_example_30", 
   "promt_example_31", 
   "promt_example_57", 
]

let listPromptExample6: [String] = [
   "promt_example_32", 
   "promt_example_33", 
   "promt_example_67", 
]

let listPromptExample7: [String] = [
   "promt_example_34", 
   "promt_example_35", 
]

let listPromptExample8: [String] = [
   "promt_example_36", 
   "promt_example_37", 
   "promt_example_38", 
   "promt_example_39", 
]

let listPromptExample9: [String] = [
   "promt_example_40", 
   "promt_example_41", 
   "promt_example_42", 
   "promt_example_43", 
   "promt_example_44", 
   "promt_example_45", 
]
