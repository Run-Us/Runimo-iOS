//
//  Home.swift
//  Runimo
//
//  Created by 가은 on 4/2/25.
//

import Foundation

struct HomeItem: Codable {
    let nickname: String
    let profile_image_url: String
    let love_point: Int
    let total_distance_in_meters: Int
    let total_running_count: Int
    let total_egg_count: Int
}
