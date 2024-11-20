//
//  ParticipantInfo.swift
//  RunUs
//
//  Created by byeoungjik on 10/1/24.
//

import Foundation

struct ParticipationResponse: Codable {
    let success: Bool
    let message: String
    let code: String
    let payload: [AggregateParticipants]?
}

struct AggregateParticipants: Codable {
    let name: String
    let imgUrl: String?
    let totalDistanceInMeters: Int?
}

struct EnterGroupRunResponse: Codable {
    let success: Bool
    let message: String
    let code: String
    let payload: runningId
}

struct runningId: Codable {
    let runningId: String
}
