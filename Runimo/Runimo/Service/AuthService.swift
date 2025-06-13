//
//  AuthService.swift
//  RunUs
//
//  Created by 가은 on 9/29/24.
//

import Alamofire
import Foundation
import KeychainSwift
import SwiftUI

final class AuthService: ObservableObject {
    static let shared = AuthService()
    private let keychain = KeychainSwift()
    let baseUrl = "https://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"
    
    private init() { }
    
    // 회원가입
    func signup(nickname: String, image: UIImage? = nil, gender: String, completion: @escaping ((String, String)) -> Void) {
        let path = "\(baseUrl)/auth/signup"
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data"
        ]
        
        let registerToken = self.keychain.get("register_token") ?? ""
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
                    self.saveUserInfo(user: data)
                    self.keychain.delete("register_token")
                    completion((data.greeting_egg_name, data.greeting_egg_img_url))
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
            "oidc_token": keychain.get("idToken") ?? ""
        ]
        
        let dataRequest = APIRequest(path: path, method: .post, parameters: body)
        
        NetworkManager.shared.getHTTPStatusCode(dataRequest) { code in
            if code == 200 {
                // 로그인
                NetworkManager.shared.request(dataRequest) { (result: Result<UserToken, AFError>) in
                    switch result {
                    case .success(let data):
                        self.saveUserInfo(user: data)
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
            "auth_code": keychain.get("authCode") ?? "",
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
                        self.saveUserInfo(user: result)
                        completion(200)
                    }
                    
                case 404:
                    if let success = try? JSONDecoder().decode(BaseErrorResponse.self, from: data) {
                        self.keychain.set(success.temporal_register_token, forKey: "register_token")
                        completion(404)
                    }
                    
                default:
                    break
                }
            }
        
    }
    
    // 토큰 갱신
    func refreshToken(completion: @escaping (Bool) -> Void) {
        let path = "\(baseUrl)/auth/refresh"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("refreshToken") ?? "")"
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
                        print("❕ Token Refresh success: Request URL: \(path)\n")
                        self.saveToken(accessToken: result.access_token, refreshToken: result.refresh_token)
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
    
    // 유저 정보 저장
    private func saveUserInfo(user: UserToken) {
        UserDefaults.standard.set(user.nickname, forKey: "nickname")
        saveToken(accessToken: user.access_token, refreshToken: user.refresh_token)
    }
    
    private func saveUserInfo(user: SignUpResponse) {
        UserDefaults.standard.set(user.nickname, forKey: "nickname")
        saveToken(accessToken: user.token_pair.access_token, refreshToken: user.token_pair.refresh_token)
    }
    
    private func saveToken(accessToken: String, refreshToken: String) {
        self.keychain.set(accessToken, forKey: "accessToken")
        self.keychain.set(refreshToken, forKey: "refreshToken")
    }
    
    // 저장된 유저 정보 삭제
    func removeUserInfoToLogout() {
        UserDefaults.standard.removeObject(forKey: "nickname")
        self.keychain.delete("accessToken")
        self.keychain.delete("refreshToken")
    }
}
