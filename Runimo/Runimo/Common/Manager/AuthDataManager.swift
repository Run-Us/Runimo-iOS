//
//  AuthDataManager.swift
//  Runimo
//
//  Created by 가은 on 8/30/25.
//

import Foundation
import KeychainSwift

final class AuthDataManager {
    private let keychain = KeychainSwift()
    private let userDefaults = UserDefaults.standard
    
    // set
    func saveUserInfo(nickname: String, accessToken: String, refreshToken: String) {
        userDefaults.set(nickname, forKey: "nickname")
        saveToken(accessToken: accessToken, refreshToken: refreshToken)
    }
    
    func saveToken(accessToken: String, refreshToken: String) {
        keychain.set(accessToken, forKey: "accessToken")
        keychain.set(refreshToken, forKey: "refreshToken")
    }
    
    func saveIdToken(idToken: String) {
        keychain.set(idToken, forKey: "idToken")
    }
    
    func saveAuthCode(authCode: String) {
        keychain.set(authCode, forKey: "authCode")
    }
    
    func saveRegisterToken(token: String) {
        keychain.set(token, forKey: "registerToken")
    }
    
    // get
    func getAccessToken() -> String? {
        return keychain.get("accessToken")
    }
    
    func getRefreshToken() -> String? {
        return keychain.get("refreshToken")
    }
    
    func getIdToken() -> String? {
        return keychain.get("idToken")
    }
    
    func getAuthCode() -> String? {
        return keychain.get("authCode")
    }
    
    func getRegisterToken() -> String? {
        return keychain.get("registerToken")
    }
    
    // delete
    func removeUserInfo() {
        UserDefaults.standard.removeObject(forKey: "nickname")
        keychain.delete("accessToken")
        keychain.delete("refreshToken")
    }
    
    func removeRegisterToken() {
        keychain.delete("registerToken")
    }
}
