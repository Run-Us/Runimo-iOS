//
//  BaseResponse.swift
//  RunUs
//
//  Created by byeoungjik on 11/20/24.
//

import Alamofire
import Foundation

class BaseResponse<T: Codable>: Codable {
    let success: Bool
    let message: String
    let code: String
    let payload: T?
}

class BaseErrorResponse: Codable {
    let success: Bool
    let message: String
    let code: String
    let temporal_register_token: String
}

struct APIRequest {
    let path: String
    let method: HTTPMethod
    let parameters: Parameters?
    let encoding: ParameterEncoding
    let headers: HTTPHeaders?

    init(
        path: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        headers: HTTPHeaders? = ["Content-Type": "application/json"]
    ) {
        self.path = path
        self.method = method
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
    }
}
