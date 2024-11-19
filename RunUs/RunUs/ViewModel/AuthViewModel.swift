//
//  AuthViewModel.swift
//  RunUs
//
//  Created by 가은 on 9/5/24.
//

import Foundation
import KakaoSDKUser
import KeychainSwift

class AuthViewModel: ObservableObject {
    let keychain = KeychainSwift()
    
    func kakaoLogin(completion: @escaping (_ result: Int) -> Void) {
        // 카카오톡 실행 가능 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡 로그인
            UserApi.shared.loginWithKakaoTalk(nonce: generateRandomString()) { oauthToken, error in
                if let error = error {
                    print(error)
                    completion(0)
                } else {
                    // idToken 저장
                    if let idToken = oauthToken?.idToken {
                        self.keychain.set(idToken, forKey: "idToken")
                        UserDefaults.standard.set(idToken, forKey: "idToken")   // 기기에 저장 (자동로그인)
                        AuthService().login(provider: "KAKAO") { result in
                            completion(result)
                        }
                    }
                }
            }
        } else {
            // 카카오계정 로그인
            UserApi.shared.loginWithKakaoAccount(nonce: generateRandomString()) { oauthToken, error in
                if let error = error {
                    print(error)
                    completion(0)
                } else {
                    // idToken 저장
                    if let idToken = oauthToken?.idToken {
                        self.keychain.set(idToken, forKey: "idToken")
                        UserDefaults.standard.set(idToken, forKey: "idToken")   // 기기에 저장 (자동로그인)
                        AuthService().login(provider: "KAKAO") { result in
                            completion(result)
                        }
                    }
                }
            }
        }
    }
    
    // 로그인된 토큰이 존재하는지 확인
    func checkTokenExists() -> Bool {
        if let accessToken = keychain.get("accessToken") {
            // TODO: 서버 API 연결
            
            return true
        }
        return false
    }
    
}

func generateRandomString() -> String {
    var result = ""
    
    for _ in 0..<8 {
        let randomValue = Int.random(in: 0...255)
        result += String(format: "%02X", randomValue)
    }
    
    return result
}
