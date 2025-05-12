//
//  Character.swift
//  Runimo
//
//  Created by 가은 on 3/26/25.
//

import Foundation

struct CharacterItem: Hashable {
    let name: String
    let imageName: String
    let disabled: Bool
}

struct RunimoIdResponse: Codable {
    let main_runimo_id: Int
}

// MARK: - 고정 러니모 조회
struct GetAllRunimo: Codable {
    let runimo_groups: [RunimoGroup]
}

struct RunimoGroup: Codable {
    let egg_type: String
    let egg_required_distance_in_meters: Int
    let runimo_types: [RunimoInfo]?
}

struct RunimoInfo: Codable {
    let name: String
    let img_url: String
    let code: String
    let description: String
}

// MARK: - 보유 러니모 조회
struct GetMyRunimo: Codable {
    let total_distance_in_meters: Int
    let runimos: [UserInfoWithRunimo]
}

struct UserInfoWithRunimo: Codable {
    let id: Int
    let code: String
    let total_run_count: Int
    let total_distance_in_meters: Int
    let is_main_runimo: Bool
}
