//
//  AuthService.swift
//  RunUs
//
//  Created by 가은 on 9/29/24.
//

import Alamofire
import Foundation
import KeychainSwift

final class AuthService: ObservableObject {
    static let shared = AuthService()
    let keychain = KeychainSwift()
    
    private init() {}
    
    // 회원가입
    func signup(nickname: String, imageURL: String? = nil, gender: String, completion: @escaping (Bool) -> Void) {
        let path = "/auth/signup"
        let body: [String: Any] = [
            "register_token": keychain.get("register_token") ?? "",
            "nickname": nickname,
            "img_url": imageURL ?? ""
        ]
        
        let dataRequest = APIRequest(path: path, method: .post, parameters: body)
        
        NetworkManager.shared.request(dataRequest) { (result: Result<SignUpResponse, AFError>) in
            switch result {
            case .success(let data):
                self.saveUserInfo(user: data)
                self.keychain.delete("register_token")
                print("\(data)")
                DispatchQueue.main.async {
                    print("📤 posting completeSignUp notification")
                    NotificationCenter.default.post(name: .completeSignUp, object: nil, userInfo: nil)
                }
                completion(true)
            case .failure(let error):
                print("\(error)")
                completion(false)
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
            } else {
                NetworkManager.shared.requestLoginError(dataRequest)
                completion(code)
            }
        }
    }
    
    func appleLogin(codeVerifier: String, completion: @escaping (Int) -> Void) {
        let baseUrl = "http://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"
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
    
    private func saveUserInfo(user: UserToken) {
        UserDefaults.standard.set(user.nickname, forKey: "nickname")
        self.keychain.set(user.access_token, forKey: "accessToken")
        self.keychain.set(user.refresh_token, forKey: "refreshToken")
    }
    
    private func saveUserInfo(user: SignUpResponse) {
        UserDefaults.standard.set(user.nickname, forKey: "nickname")
        self.keychain.set(user.token_pair.access_token, forKey: "accessToken")
        self.keychain.set(user.token_pair.refresh_token, forKey: "refreshToken")
    }
}
