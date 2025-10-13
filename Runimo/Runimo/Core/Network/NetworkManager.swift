//
//  NetworkManager.swift
//  Runimo
//
//  Created by 가은 on 4/4/25.
//

import Alamofire
import Combine
import Foundation

final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private let tokenManager = TokenManager()
    private let baseUrl = "https://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"
    
    private var isTokenRefreshing = false
    private var refreshQueue: [(Bool) -> Void] = []
    
    private let session: Session
    
    private init() {
        let authInterceptor = AuthInterceptor(tokenManager: TokenManager())
        self.session = Session(interceptor: authInterceptor)
    }
    
    // http 응답코드 받기
    func getHTTPStatusCode(
        _ request: APIRequest,
        completion: @escaping (Int) -> Void)
    {
        let url = "\(baseUrl)\(request.path)"
        session.request(url, method: request.method, parameters: request.parameters, encoding: request.encoding, headers: request.headers)
            .validate(statusCode: 100..<600)
            .response { response in
                let statusCode = response.response?.statusCode ?? -1
                print("Request URL: \(url)\n📡 Status Code: \(statusCode)")
                completion(statusCode)
            }
    }
    
    // 요청
    func request<T: Codable>(
        _ request: APIRequest,
        completion: @escaping (Result<T, AFError>) -> Void)
    {
        let url = "\(baseUrl)\(request.path)"
        print("url: \(url)\nparameters: \(String(describing: request.parameters))\n")
        session.request(url, method: request.method, parameters: request.parameters, encoding: request.encoding, headers: request.headers)
            .validate()  // ✅ 401 등의 에러를 감지하여 Interceptor 동작
            .responseDecodable(of: BaseResponse<T>.self) { response in
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
    
    func request<T: Codable>(
        _ request: APIRequest) -> AnyPublisher<T, AFError>
    {
        let url = "\(baseUrl)\(request.path)"
        print("url: \(url)\nparameters: \(String(describing: request.parameters))\n")

        return session.request(
            url,
            method: request.method,
            parameters: request.parameters,
            encoding: request.encoding,
            headers: request.headers
        )
        .validate()  // ✅ 401 등의 에러를 감지하여 Interceptor 동작
        .publishDecodable(type: BaseResponse<T>.self)
        .value()
        .tryMap({ response in
            guard let data = response.payload else {
                print("⚠️ Payload is nil. Code: \(response.code), Message: \(response.message)\n")
                throw AFError.responseValidationFailed(reason: .dataFileNil)
            }
            return data
        })
        .mapError({ error in
            print("❌ Request Failed: \(url)\n\(error.localizedDescription)")
            if let aferror = error as? AFError {
                return aferror
            } else {
                return AFError.responseValidationFailed(reason: .customValidationFailed(error: error))
            }
        })
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func requestLoginError(_ request: APIRequest)
    {
        let url = "\(baseUrl)\(request.path)"
        print("url: \(url)\nparameters: \(String(describing: request.parameters))\n")
        session.request(url, method: request.method, parameters: request.parameters, encoding: request.encoding, headers: request.headers)
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
