//
//  MemberInfo.swift
//  RunUs
//
//  Created by byeoungjik on 10/1/24.
//

import Foundation

struct UserToken: Codable {
    let nickname: String
    let img_url: String
    let access_token: String
    let refresh_token: String
}

struct SignUpResponse: Codable {
    let user_id: Int
    let nickname: String
    let img_url: String
    let token_pair: Token
}

struct Token: Codable {
    let access_token: String
    let refresh_token: String
}

struct MyPage: Codable {
    let profile_image_url: String?
    let nickname: String
    let total_distance_in_meters: Int
    let latest_run_date_before: Int
    let latest_running_record_nullable: RunningRecord?
}

struct RunningGraph: Codable {
    let total_count: Int
    let total_distance: Int
    let total_time: Int
    let distance_list: [Int]
}
