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

struct MyPage: Codable {
    let profileImage: String?
    let nickname: String
    let totalDistance: Int
    let recentRunningDate: Date?
    let runningRecords: [RunningRecord?]
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image_url"
        case nickname = "nickname"
        case totalDistance = "total_running_distance_in_meters"
        case recentRunningDate = "recent_running_date"
        case runningRecords = "running_records"
    }
}

struct RunningGraph: Codable {
    let total_count: Int
    let total_distance: Int
    let total_time: Int
    let distance_list: [Int]
}
