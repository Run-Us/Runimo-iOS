//
//  ParticipantInfo.swift
//  RunUs
//
//  Created by byeoungjik on 10/1/24.
//

import Foundation

struct AggregateParticipants: Codable {
    let name: String
    let imgUrl: String?
    let totalDistanceInMeters: Int?
}

struct RunningId: Codable {
    let runningId: String
}
