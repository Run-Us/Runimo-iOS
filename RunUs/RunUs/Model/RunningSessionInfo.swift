//
//  RunningSession.swift
//  RunUs
//
//  Created by byeoungjik on 9/30/24.
//

import Foundation

struct RunningSessionInfo: Codable {
    let runningId: String
    let passcode: String
}

struct RunningSession: Codable {
    var constraints: RunningSessionConstraints
    var description: RunningSessionDescription
    var startLocation: UserLocation
}

struct RunningSessionConstraints: Codable {
    var maxParticipantCount: Int
    var minPace: Int
}

struct RunningSessionDescription: Codable {
    var title: String
    var desc: String
    var distance: String
    var runningTime: String
}

struct UserLocation: Codable {
    var latitude: Double
    var longitude: Double
}

struct SessionCardInfo: Codable {
    let runing_public_id: String
    let top_message: String
    let title: String
    let description: String
    let start_at: String
    let pace_list: [String]
    let participant_count: Int
    let created_by: SessionCreator
    let crew: SessionCrew
}

struct SessionCreator: Codable {
    let nickname: String
    let profile_image: String?
}

struct SessionCrew: Codable {
    let crew_public_id: String
    let profile_image: String?
    let name: String
}
