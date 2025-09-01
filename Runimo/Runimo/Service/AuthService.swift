//
//  AuthService.swift
//  RunUs
//
//  Created by 가은 on 9/29/24.
//

import Alamofire
import Foundation
import SwiftUI

final class AuthService: ObservableObject {
    static let shared = AuthService()
    private let tokenManager = TokenManager()
    let baseUrl = "https://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"
    
    private let networkManager: NetworkManagerProtocol
    
    private init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    // 회원가입
    func signup(nickname: String, image: UIImage? = nil, gender: String, completion: @escaping (Int, String) -> Void) {
        let path = "\(baseUrl)/auth/signup"
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data"
        ]
        
        let registerToken = tokenManager.getRegisterToken() ?? ""
        let jsonBody = """
        {
            "register_token": "\(registerToken)",
            "nickname": "\(nickname)",
            "gender": "\(gender)"
        }
        """
        
        AF.upload(multipartFormData: { multipartFormData in
            if let jsonData = jsonBody.data(using: .utf8) {
                multipartFormData.append(jsonData, withName: "request", mimeType: "application/json")
            }
            if let image = image, let imageData = image.jpegData(compressionQuality: 0.8) {
                multipartFormData.append(imageData, withName: "profileImage", fileName: "profile.jpg", mimeType: "image/jpeg")
            }
        }, to: path, method: .post, headers: headers)
        .responseDecodable(of: BaseResponse<SignUpResponse>.self) { response in
            switch response.result {
            case .success(let response):
                if let data = response.payload {
                    self.tokenManager.saveUserInfo(nickname: data.nickname, accessToken: data.token_pair.access_token, refreshToken: data.token_pair.refresh_token)
                    self.tokenManager.removeRegisterToken()
                    completion(data.egg_id, data.egg_code)
                }
            case .failure(let error):
                print("DEBUG(edit profile image api) error: \(error)")
            }
        }
    }
    
    // 로그인
    func kakaoLogin(completion: @escaping (Int) -> Void) {
        let path = "/auth/kakao"
        let body: [String: Any] = [
            "oidc_token": tokenManager.getIdToken() ?? ""
        ]
        
        let dataRequest = APIRequest(path: path, method: .post, parameters: body)
        
        networkManager.getHTTPStatusCode(dataRequest) { code in
            if code == 200 {
                // 로그인
                self.networkManager.request(dataRequest) { (result: Result<UserToken, AFError>) in
                    switch result {
                    case .success(let data):
                        self.tokenManager.saveUserInfo(nickname: data.nickname, accessToken: data.access_token, refreshToken: data.refresh_token)
                        print("\(data)")
                        completion(200)
                    case .failure(let error):
                        print("\(error)")
                        completion(0)
                    }
                }
            } else if code == 404 {
                NetworkManager.shared.requestLoginError(dataRequest)
                completion(code)
            }
        }
    }
    
    func appleLogin(codeVerifier: String, completion: @escaping (Int) -> Void) {
        let path = "\(baseUrl)/auth/apple"
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let body: [String: Any] = [
            "auth_code": tokenManager.getAuthCode() ?? "",
            "code_verifier": codeVerifier
        ]
        
        AF.request(path, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .responseData { response in
                let statusCode = response.response?.statusCode ?? 0
                guard let data = response.data else { return }
                
                switch statusCode {
                case 200:
                    if let success = try? JSONDecoder().decode(BaseResponse<UserToken>.self, from: data),
                       let result = success.payload
                    {
                        self.tokenManager.saveUserInfo(nickname: result.nickname, accessToken: result.access_token, refreshToken: result.refresh_token)
                        completion(200)
                    }
                    
                case 404:
                    if let success = try? JSONDecoder().decode(BaseErrorResponse.self, from: data) {
                        self.tokenManager.saveRegisterToken(token: success.temporal_register_token)
                        completion(404)
                    }
                    
                default:
                    break
                }
            }
        
    }
    
    func logout(completion: @escaping (Bool) -> Void) {
        let path = "/auth/log-out"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(tokenManager.getAccessToken() ?? "")"
        ]
        
        let dataRequest = APIRequest(path: path, method: .post, encoding: JSONEncoding.default, headers: headers)
        
        networkManager.getHTTPStatusCode(dataRequest) { code in
            self.tokenManager.removeUserInfo()
            print("logout", code)
            completion(code == 200)
        }
    }
    
    // 토큰 갱신 (자동로그인 확인용)
    func refreshToken(completion: @escaping (Bool) -> Void) {
        let path = "\(baseUrl)/auth/refresh"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(tokenManager.getRefreshToken() ?? "")"
        ]
        
        AF.request(path, method: .post, encoding: JSONEncoding.default, headers: headers)
            .responseData { response in
                let statusCode = response.response?.statusCode ?? 0
                guard let data = response.data else { return }
                
                switch statusCode {
                case 200:
                    if let success = try? JSONDecoder().decode(BaseResponse<Token>.self, from: data),
                       let result = success.payload
                    {
                        print("❕(Temp) Token Refresh success: Request URL: \(path)\n")
                        self.tokenManager.saveToken(accessToken: result.access_token, refreshToken: result.refresh_token)
                        completion(true)
                    } else {
                        completion(false)
                    }
                default:
                    print("❌ Token Refresh Failed: Request URL: \(path)\n")
                    completion(false)
                }
            }
    }
    
}
