//
//  BaseResponse.swift
//  RunUs
//
//  Created by byeoungjik on 11/20/24.
//

import Foundation

class BaseResponse<T: Codable>: Codable {
    let success: Bool
    let message: String
    let code: String
    let payload: T?
}
