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

struct RunningResult: Codable {
    var started_at: Date?
    var end_at: Date?
    var total_distance_in_meters: Int?
    var average_pace_in_milli_seconds: Int?
    var segment_paces: [SegmentPaces]?
}

struct SegmentPaces: Codable {
    let distance: Int
    let pace: Int
}

struct Location: Codable {
    var userKey: String
    var x: Double
    var y: Double
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
    let title: String
    let start_date_time: Date
    let distance_in_meters: Int
    let duration_in_seconds: Int
    let average_pace_in_miliseconds: Int
}

struct SaveRunningResponse: Codable {
    let saved_id: String
}
