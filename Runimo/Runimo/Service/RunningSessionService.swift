//
//  RunningSessionService.swift
//  RunUs
//
//  Created by byeoungjik on 9/30/24.
//

import Foundation
import KeychainSwift
import CoreLocation
import Alamofire

class RunningSessionService: ObservableObject {
    static let shared = RunningSessionService()
    let keychain = KeychainSwift()
    let baseUrl = "http://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"
    
    private init() { }
    
    func saveRunningRecords(running: RunningResult, retrying: Bool = false, completion: @escaping (Bool) -> Void) {
        let path = "\(baseUrl)/records"
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        AF.request(path, method: .post, parameters: running, encoder: JSONParameterEncoder.default, headers: headers)
            .responseDecodable(of: BaseResponse<SaveRunningResponse>.self) { response in
                
                // 토큰 갱신
                if let statusCode = response.response?.statusCode, statusCode == 401, !retrying {
                    AuthService.shared.refreshToken { success in
                        if success {
                            // new token으로 재요청
                            headers["Authorization"] = "Bearer \(self.keychain.get("accessToken") ?? "")"
                            
                            self.saveRunningRecords(running: running, retrying: true) { result in
                                completion(result)
                            }
                        }
                    }
                    return
                }
             
            switch response.result {
            case .success(let result):
                print(result.message, result.code, result.success, response.response?.statusCode)
                print("runningId: \(result.payload?.saved_id ?? "")")
                completion(true)
            case .failure(let error):
                print("❌ Request Failed: Request URL: \(path)\n\(error.localizedDescription)")
                completion(false)
            }
        }
        
    }
}



