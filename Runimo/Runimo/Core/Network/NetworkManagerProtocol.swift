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
}
