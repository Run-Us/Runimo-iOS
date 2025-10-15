//
//  AuthInterceptor.swift
//  Runimo
//
//  Created by 가은 on 9/1/25.
//

import Alamofire
import Foundation

extension TokenManager: @unchecked Sendable {}

final class AuthInterceptor: RequestInterceptor {
    private let tokenManager: TokenManager
    
    init(tokenManager: TokenManager) {
        self.tokenManager = tokenManager
    }
    
    // 요청 헤더에 최신 토큰을 주입하는 역할
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.headers.update(name: "Content-Type", value: "application/json")
        if let accessToken = tokenManager.getAccessToken() {
            urlRequest.headers.update(name: "Authorization", value: "Bearer \(accessToken)")
        }
        completion(.success(urlRequest))
    }
    
    // 401 에러 발생 시 토큰을 갱신하고 재요청을 시도하는 역할
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void)
    {
        // HTTP 상태 코드가 401인지 확인
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        // 토큰 갱신 시도
        guard let refreshToken = tokenManager.getRefreshToken() else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        let path = "https://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")/auth/refresh"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(refreshToken)"
        ]
        
        AF.request(path, method: .post, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: BaseResponse<Token>.self) { response in
                switch response.result {
                case .success(let baseResponse):
                    if let result = baseResponse.payload {
                        self.tokenManager.saveToken(accessToken: result.access_token, refreshToken: result.refresh_token)
                        print("❕ Token Refresh success: Request URL: \(path)\n")
                        completion(.retry) // 토큰 갱신 성공 시 재요청
                    } else {
                        completion(.doNotRetryWithError(error))
                    }
                case .failure(let error):
                    print("❌ Token Refresh Failed: Request URL: \(path)\n")
                    completion(.doNotRetryWithError(error))
                }
            }
    }
}
