//
//  MemberInfo.swift
//  RunUs
//
//  Created by byeoungjik on 10/1/24.
//

import Foundation

struct JoinResponse: Codable {
    let message: String
    let success: Bool
    let code: String
    let payload: UserToken?
}

struct UserToken: Codable {
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
