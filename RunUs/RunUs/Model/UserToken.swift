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
    let payload: UserToken
}

struct UserToken: Codable {
    let accessToken: String
    let refreshToken: String
}

