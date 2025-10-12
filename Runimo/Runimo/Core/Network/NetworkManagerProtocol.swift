//
//  NetworkManagerProtocol.swift
//  Runimo
//
//  Created by 가은 on 8/31/25.
//

import Alamofire
import Combine
import Foundation

protocol NetworkManagerProtocol: AnyObject {
    func getHTTPStatusCode(_ request: APIRequest, completion: @escaping (Int) -> Void)
    func request<T: Codable>(_ request: APIRequest, completion: @escaping (Result<T, AFError>) -> Void)
    func requestLoginError(_ request: APIRequest)
    func refreshToken(completion: @escaping (Bool) -> Void)
    func request<T: Codable>(_ request: APIRequest) -> AnyPublisher<T?, AFError>
}
