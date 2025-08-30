//
//  NetworkManager.swift
//  Runimo
//
//  Created by 가은 on 4/4/25.
//

import Alamofire
import Foundation

final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private let tokenManager = TokenManager()
    private let baseUrl = "https://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"
    
    private var isTokenRefreshing = false
    private var refreshQueue: [(Bool) -> Void] = []
    
    private init() { }
    
    // http 응답코드 받기
    func getHTTPStatusCode(
        _ request: APIRequest,
        retrying: Bool = false,
        completion: @escaping (Int) -> Void)
    {
        let url = "\(baseUrl)\(request.path)"
        AF.request(url, method: request.method, parameters: request.parameters, encoding: request.encoding, headers: request.headers)
            .validate(statusCode: 100..<600)
            .response { response in
                let statusCode = response.response?.statusCode ?? -1
                // 토큰 갱신
                if statusCode == 401 {
                    self.refreshToken { success in
                        if success {
                            // new token으로 재요청
                            var updateHeaders: HTTPHeaders = request.headers ?? [:]
                            updateHeaders["Authorization"] = "Bearer \(self.tokenManager.getAccessToken() ?? "")"
                            let dataRequest = APIRequest(path: request.path, method: request.method, parameters: request.parameters, encoding: request.encoding, headers: updateHeaders)
                            self.getHTTPStatusCode(dataRequest, retrying: true) { result in
                                completion(result)
                            }
                        }
                    }
                } else {
                    print("Request URL: \(url)\n📡 Status Code: \(statusCode)")
                    completion(statusCode)
                }
                
            }
    }
    
    // 요청
    func request<T: Codable>(
        _ request: APIRequest,
        retrying: Bool = false,
        completion: @escaping (Result<T, AFError>) -> Void)
    {
        let url = "\(baseUrl)\(request.path)"
        print("url: \(url)\nparameters: \(String(describing: request.parameters))\n")
        AF.request(url, method: request.method, parameters: request.parameters, encoding: request.encoding, headers: request.headers)
            .responseDecodable(of: BaseResponse<T>.self) { response in
                // 토큰 갱신
                if let statusCode = response.response?.statusCode, statusCode == 401, !retrying {
                    self.refreshToken { success in
                        if success {
                            // new token으로 재요청
                            var updateHeaders: HTTPHeaders = request.headers ?? [:]
                            updateHeaders["Authorization"] = "Bearer \(self.tokenManager.getAccessToken() ?? "")"
                            let dataRequest = APIRequest(path: request.path, method: request.method, parameters: request.parameters, encoding: request.encoding, headers: updateHeaders)
                            self.request(dataRequest, retrying: true) { (result: Result<T, AFError>) in
                                completion(result)
                            }
                        }
                    }
                    return
                }
            switch response.result {
            case .success(let baseResponse):
                if let data = baseResponse.payload {
                    completion(.success(data))
                } else {
                    // payload가 없을 때도 실패로 처리
                    print("⚠️ Payload is nil. StatusCode: \(response.response?.statusCode ?? 0) \nCode: \(baseResponse.code), Message: \(baseResponse.message)\n")
                    completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                }
            case .failure(let error):
                print("❌ Request Failed: Request URL: \(url)\n\(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func requestLoginError(_ request: APIRequest)
    {
        let url = "\(baseUrl)\(request.path)"
        print("url: \(url)\nparameters: \(String(describing: request.parameters))\n")
        AF.request(url, method: request.method, parameters: request.parameters, encoding: request.encoding, headers: request.headers)
            .responseDecodable(of: BaseErrorResponse.self) { response in
            switch response.result {
            case .success(let result):
                self.tokenManager.saveRegisterToken(token: result.temporal_register_token)
            case .failure(let error):
                print("❌ Request 404 Failed: Request URL: \(url)\n\(error.localizedDescription)\n")
            }
        }
    }
    
    func refreshToken(completion: @escaping (Bool) -> Void) {
        // 토큰 갱신 요청 중일 때 대기 중인 큐에 넣기
        if isTokenRefreshing {
            refreshQueue.append(completion)
            return
        }
        
        isTokenRefreshing = true
        
        AuthService.shared.refreshToken { success in
            self.isTokenRefreshing = false
            
            completion(success)
            self.refreshQueue.forEach { $0(success) }
            self.refreshQueue.removeAll()
        }
    }
}
