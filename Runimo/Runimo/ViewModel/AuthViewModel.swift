//
//  AuthViewModel.swift
//  RunUs
//
//  Created by 가은 on 9/5/24.
//

import AuthenticationServices
import Foundation
import KakaoSDKUser
import KeychainSwift
import SwiftUI

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
                        AuthService.shared.kakaoLogin { result in
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
                        AuthService.shared.kakaoLogin { result in
                            completion(result)
                        }
                    }
                }
            }
        }
    }
    
    func appleLogin(_ result: ASAuthorization, completion: @escaping (_ result: Int) -> Void) {
        switch result.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let idToken = String(data: appleIDCredential.identityToken ?? Data(), encoding: .utf8)
            let authCode = String(data: appleIDCredential.authorizationCode ?? Data(), encoding: .utf8)
            
            if let idToken = idToken, let authCode = authCode {
                keychain.set(idToken, forKey: "idToken")
                keychain.set(authCode, forKey: "authCode")
                AuthService.shared.appleLogin(codeVerifier: generateCodeVerifier()) { result in
                    completion(result)
                }
            }
        default: break
        }
    }
    
    func generateRandomString() -> String {
        var result = ""
        
        for _ in 0..<8 {
            let randomValue = Int.random(in: 0 ... 255)
            result += String(format: "%02X", randomValue)
        }
        
        return result
    }
    
    func generateCodeVerifier(length: Int = 64) -> String {
        let charset = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        var result = ""
        for _ in 0..<length {
            result.append(charset.randomElement()!)
        }
        return result
    }
}
