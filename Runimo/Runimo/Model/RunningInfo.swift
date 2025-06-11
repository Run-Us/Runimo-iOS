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
    var total_time_in_seconds: Int?
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
    let id: String?
    let title: String
    let start_date_time: String
    let distance_in_meters: Int
    let duration_in_seconds: Int
    let average_pace_in_miliseconds: Int
}

struct SaveRunningResponse: Codable {
    let saved_id: String
}

// MARK: - 러닝 기록
struct RunningRecordResponse: Codable {
    let simple_stat: SimpleStat
    let daily_stats: [DailyStats]
}

struct SimpleStat: Codable {
    let total_time_in_seconds: Int
    let total_running_count: Int
    let total_distance_in_meters: Int
}

struct DailyStats: Codable {
    let date: String
    let distance_in_meters: Int
}

// 러닝 완료 보상
struct RewardResponse: Codable {
    let is_rewarded: Bool
    let egg_code: String
    let egg_type: String
    let love_point_amount: Int
}

struct RunningRecordsResponse: Codable {
    let items: [RunningRecord]
    let pagination: RecordPagination
}

struct RecordPagination: Codable {
    let total_items: Int
    let total_pages: Int
    let current_page: Int
    let per_page: Int
}

struct RunningPostResponse: Codable {
    let record_id: String
    let title: String
    let description: String?
    let started_at: String
    let end_at: String
    let total_running_time: Int
    let average_pace: Int
    let total_distance: Int
    let segment_pace_list: [SegmentPaces]
    let img_url: String?
}
