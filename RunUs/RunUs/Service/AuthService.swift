//
//  AuthService.swift
//  RunUs
//
//  Created by 가은 on 9/29/24.
//

import Alamofire
import Foundation
import KeychainSwift

class AuthService: ObservableObject {
    let keychain = KeychainSwift()
    let baseUrl = "http://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"
    
    // 회원가입
    func signup(nickName: String, provider: String, gender: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(baseUrl)/auth/signup")!
        let headers = ["Content-Type": "application/json"]
        
        let joinData = ["oidc_token": keychain.get("idToken") ?? "", "provider": provider, "nickname": nickName, "gender": gender]
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
                    let response = try JSONDecoder().decode(BaseResponse<UserToken>.self, from: data)
                    DispatchQueue.main.async {
                        if response.success {
                            if let payload = response.payload {
                                self.keychain.set(payload.access_token, forKey: "accessToken")
                                self.keychain.set(payload.refresh_token, forKey: "refreshToken")
                                UserDefaults.standard.set(nickName, forKey: "nickname")
                            }
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
                print("SignUp Failed : \(String(decoding: data, as: UTF8.self))")
                completion(false)
            }
        }.resume()
    }
    
    // 로그인
    func login(provider: String, completion: @escaping (Int) -> Void) {
        let url = "\(baseUrl)/auth/login"
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let body: [String: Any] = [
            "oidc_token": keychain.get("idToken") ?? "",
            "provider": provider
        ]
        
        let dataRequest = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
        
        dataRequest.responseDecodable(of: BaseResponse<UserToken>.self) { response in
            switch response.result {
            case .success(let response):
                if response.code == "UEH4031" {
                    // 회원가입
                    completion(403)
                } else if response.code == "USH2003" {
                    // 로그인 성공
                    if let payload = response.payload {
                        self.keychain.set(payload.access_token, forKey: "accessToken")
                        self.keychain.set(payload.refresh_token, forKey: "refreshToken")
                    }
                    completion(200)
                }
            case .failure(let error):
                print("Login Failed: \(error)")
                completion(0)
            }
        }
    }
}
