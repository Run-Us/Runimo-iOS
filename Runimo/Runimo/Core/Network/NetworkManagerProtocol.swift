//
//  NetworkManagerProtocol.swift
//  Runimo
//
//  Created by 가은 on 8/31/25.
//

import Alamofire
import Foundation

protocol NetworkManagerProtocol: AnyObject {
    func getHTTPStatusCode(_ request: APIRequest, retrying: Bool, completion: @escaping (Int) -> Void)
    func request<T: Codable>(_ request: APIRequest, retrying: Bool, completion: @escaping (Result<T, AFError>) -> Void)
    func requestLoginError(_ request: APIRequest)
    func refreshToken(completion: @escaping (Bool) -> Void)
}

// retrying에 default(false) 값 부여
extension NetworkManagerProtocol {
    func getHTTPStatusCode(_ req: APIRequest, completion: @escaping (Int) -> Void) {
        getHTTPStatusCode(req, retrying: false, completion: completion)
    }
    func request<T: Codable>(_ req: APIRequest, completion: @escaping (Result<T, AFError>) -> Void) {
        request(req, retrying: false, completion: completion)
    }
}
