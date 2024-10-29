//
//  RunningInfo.swift
//  RunUs
//
//  Created by 가은 on 9/21/24.
//

import Foundation

struct RunningInfo {
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

struct AggregateInfo: Codable {
    var userId: String
    var runningId: String
    var dataList: [LocationWithCount]
}

struct LocationWithCount: Codable {
    var latitude: Double
    var longitude: Double
    var count: Int
}

struct RunningPost {
    var title: String
    var contents: String
    var runningInfo: RunningInfo
}
