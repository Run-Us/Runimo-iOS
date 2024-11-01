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
    let payload: [ParticipantInfo]?
}

struct ParticipantInfo: Codable {
    let name: String
    let imgUrl: String?
    let userId: String?
}
