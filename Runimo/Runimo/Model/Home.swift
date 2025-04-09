//
//  Home.swift
//  Runimo
//
//  Created by 가은 on 4/2/25.
//

import Foundation

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

struct HomeEggResponse: Codable {
    let incubating_eggs: [IncubatingEgg]
}

struct IncubatingEgg: Codable {
    let id: Int
    let name: String
    let img_url: String
    let hatch_required_point_amount: Int
    let current_love_point_amount: Int
    let hatchable: Bool
}
