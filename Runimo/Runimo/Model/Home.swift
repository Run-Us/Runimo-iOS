//
//  Home.swift
//  Runimo
//
//  Created by 가은 on 4/2/25.
//

import Foundation

// MARK: - Runimo
struct HomeItem: Codable {
    let main_runimo_stat_nullable: MainRunimo?
    let user_info: UserItemInfo
}

struct MainRunimo: Codable {
    let name: String
    let image_url: String
    let total_running_count: Int
    let total_distance_in_meters: Int
}

struct UserItemInfo: Codable {
    let love_point: Int
    let total_egg_count: Int
}

// MARK: - Egg
struct HomeEggResponse: Codable {
    var incubating_eggs: [IncubatingEgg]
}

struct IncubatingEgg: Codable {
    let id: Int
    let name: String
    let img_url: String
    let hatch_required_point_amount: Int
    var current_love_point_amount: Int
    let hatchable: Bool
}

struct PatchLovePointResponse: Codable {
    let egg_id: Int
    let current_love_point_amount: Int
    let required_love_point_amount: Int
    let egg_hatchable: Bool
}

struct GetMyEggs: Codable {
    let items: [EggItem]
}

struct EggItem: Codable {
    let item_id: Int
    let name: String
    let img_url: String
    let amount: Int
}

struct PostEggResponse: Codable {
    let incubating_egg_id: Int
    let current_love_point_amount: Int
    let required_love_point_amount: Int
}

struct HatchEggResponse: Codable {
    let id: Int
    let name: String
    let img_url: String
    let code: String
    let is_duplicated: Bool
}

struct CharacterPopUpItem: Codable {
    var title: String
    var subtitle: String
    var imageURL: String
    var description: String
}
