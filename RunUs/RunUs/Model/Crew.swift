//
//  Crew.swift
//  RunUs
//
//  Created by 가은 on 12/10/24.
//

import Foundation

// 크루 홈 조회
struct Crew: Codable {
    let crew_public_id: String
    let title: String
    let profile_image: String?
    let location: String
    let intro: String
    let join_type: String
    let crew_type: String
    let member_count: Int
    let created_at: String
    let exist_new_join_request: Bool
    let this_month_record: CrewMonthRecord
    let regular_running: SessionCardInfo?
    let irregular_running: SessionCardInfo?
}

struct CrewMonthRecord: Codable {
    let running_count: Int
    let total_distance: Int
    let total_time: Int
}

