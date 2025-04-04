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
    
    private init() { }
    
    // 회원가입
    func signup(nickname: String, imageURL: String? = nil, provider: String, gender: String, completion: @escaping (Bool) -> Void) {
        let path = "/users/auth/signup"
        let body: [String: Any] = [
            "oidc_token": keychain.get("idToken") ?? "",
            "provider": provider,
            "nickname": nickname,
            "img_url": imageURL ?? ""
        ]
        
        let dataRequest = APIRequest(path: path, method: .post, parameters: body)
        
        NetworkManager.shared.request(dataRequest) { (result: Result<SignUpResponse, AFError>) in
            switch result {
            case .success(let data):
                self.saveUserInfo(user: data)
                print("\(data)")
                completion(true)
            case .failure(let error):
                print("\(error)")
                completion(false)
            }
        }
    }
    
    // 로그인
    func login(provider: String, completion: @escaping (Int) -> Void) {
        let path = "/users/auth/login"
        let body: [String: Any] = [
            "oidc_token": keychain.get("idToken") ?? "",
            "provider": provider
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
                completion(code)
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
