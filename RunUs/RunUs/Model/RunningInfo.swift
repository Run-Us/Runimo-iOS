//
//  RunningInfo.swift
//  RunUs
//
//  Created by 가은 on 9/21/24.
//

import Foundation

struct RunningInfo: Codable {
    var startDate: Date?
    var endDate: Date?
    var runningTime: String?
    var averagePace: String?
    var distance: Double?
}

struct LocationResponse: Codable {
    var success: Bool
    var message: String
    var code: String
    var payload: UserLocation?
}

struct Location: Codable {
    var userKey: String
    var x: Double
    var y: Double
}

struct LocationUpdateResponse: Codable {
    var success: Bool
    var message: String
    var code: String
    var payload: Location?
}

struct RunningUpdateInfo: Codable {
    var runningId: String
    var userId: String
    var latitude: Double?
    var longitude: Double?
    var count: Int
}

struct LocationWithCount: Codable {
    var latitude: Double
    var longitude: Double
    var count: Int
}

struct RunningPost: Identifiable, Codable {
    let id = UUID()
    var createdAt: String   // Date로 수정 필요, string은 임시
    var title: String
    var contents: String
    var runningInfo: RunningInfo
}

struct RunningRecord: Codable {
    let started_at: Date
    let running_distance_in_meters: Int
    let running_duration_in_milliseconds: Int
    let average_pace_in_milliseconds: Int
}
