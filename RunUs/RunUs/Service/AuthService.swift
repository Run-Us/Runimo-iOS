//
//  AuthService.swift
//  RunUs
//
//  Created by 가은 on 9/29/24.
//

import Foundation
import KeychainSwift

class AuthService: ObservableObject {
    let keychain = KeychainSwift()
    let baseUrl = "http://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"
    let idToken = UserDefaults.standard.string(forKey: "idToken")
    
    
    func signup(nickName: String, provider: String, gender: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(baseUrl)/auth/signup")!
        let headers = ["Content-Type": "application/json"]
        
        let joinData = ["oidc_token": idToken, "provider": provider, "nickname": nickName, "gender": gender]
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "POST"
        
        do {
            let jsonData = try JSONEncoder().encode(joinData)
            request.httpBody = jsonData
        } catch {
            print("Error encoding JSON: \(error)")
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Network request failed: \(error?.localizedDescription ?? "No error info")")
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let response = try JSONDecoder().decode(JoinResponse.self, from: data)
                    DispatchQueue.main.async {
                        if response.success {
                            self.keychain.set(response.payload.access_token, forKey: "accessToken")
                            self.keychain.set(response.payload.refresh_token, forKey: "refreshToken")
                            completion(true)
                        } else {
                            completion(false)
                        }
                    }
                } catch {
                    print("Failed to decode JSON response: \(error)")
                    completion(false)
                }
            } else {
                print("not code 200 : \(response)")
                completion(false)
            }
        }.resume()
        
    }
    func login(provider: String, completion: @escaping (Bool) -> Void) {
        
        let url = URL(string: "\(baseUrl)/auth/login")!
        let headers = ["Content-Type": "application/json"]
        let loginData = ["oidc_token": idToken, "provider": provider]
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        
        do {
            let jsonData = try JSONEncoder().encode(loginData)
            request.httpBody = jsonData
        } catch {
            print("Error encoding JSON: \(error)")
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Network request failed: \(error?.localizedDescription ?? "No error info")")
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let response = try JSONDecoder().decode(JoinResponse.self, from: data)
                    DispatchQueue.main.async {
                        if response.success {
                            self.keychain.set(response.payload.access_token, forKey: "accessToken")
                            self.keychain.set(response.payload.refresh_token, forKey: "refreshToken")
                            completion(true)
                        } else {
                            completion(false)
                        }
                    }
                } catch {
                    print("Failed to decode JSON response: \(error)")
                    completion(false)
                }
            } else {
                print("HTTP Status Code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                completion(false)
            }
        }.resume()
    }
}
