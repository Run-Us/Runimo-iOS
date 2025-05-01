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
    
    func saveRunningRecords(running: RunningResult, retrying: Bool = false, completion: @escaping (Bool, String) -> Void) {
        let path = "\(baseUrl)/records"
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        let parameters: [String: Any] = [
            "started_at": DateManager.shared.getString(date: running.started_at),
            "end_at": DateManager.shared.getString(date: running.end_at),
            "total_distance_in_meters": running.total_distance_in_meters ?? 0,
            "average_pace_in_milli_seconds": running.average_pace_in_milli_seconds ?? 0,
            "segment_paces": (running.segment_paces ?? []).map {
                return [
                    "distance": $0.distance,
                    "pace": $0.pace
                ]
            }
        ]
        
        AF.request(path, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: BaseResponse<SaveRunningResponse>.self) { response in
                
                // 토큰 갱신
                if let statusCode = response.response?.statusCode, statusCode == 401, !retrying {
                    AuthService.shared.refreshToken { success in
                        if success {
                            // new token으로 재요청
                            headers["Authorization"] = "Bearer \(self.keychain.get("accessToken") ?? "")"
                            
                            self.saveRunningRecords(running: running, retrying: true) { isSuccess, result in
                                completion(isSuccess, result)
                            }
                        }
                    }
                    return
                }
             
            switch response.result {
            case .success(let result):
                if let result = result.payload {
                    print("runningId: \(result.saved_id)")
                    completion(true, result.saved_id)
                }
            case .failure(let error):
                print("❌ Request Failed: Request URL: \(path)\n\(error.localizedDescription)")
                completion(false, "")
            }
        }
        
    }
    
    // 러닝 기록 수정 
    func patchRunningRecords(runningId: String, title: String, description: String, imgURL: String, completion: @escaping (Bool) -> Void) {
        let path = "/records/\(runningId)"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        let parameters: [String: Any] = [
            "title": title,
            "description": description,
            "img_url": imgURL
        ]
        
        let dataRequest = APIRequest(path: path, method: .patch, parameters: parameters, headers: headers)
        NetworkManager.shared.getHTTPStatusCode(dataRequest) { result in
            if result == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    // 러닝 보상 획득
    func getRunningReward(runningId: String, completion: @escaping (RewardResponse) -> Void) {
        let path = "/rewards/runnings"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        let parameters: [String: Any] = [
            "record_id": runningId
        ]
        
        let dataRequest = APIRequest(path: path, method: .post, parameters: parameters, headers: headers)
        
        NetworkManager.shared.request(dataRequest) { (result: Result<RewardResponse, AFError>) in
            switch result {
            case .success(let data):
                print("러닝 보상 획득: \(data)")
                completion(data)
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    func getMyRunningRecords(page: Int, completion: @escaping (RunningRecordsResponse) -> Void) {
        let path = "/records/me"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        let parameters: [String: Any] = [
            "page": page,
            "size": 10
        ]
        
        let dataRequest = APIRequest(path: path, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)

        NetworkManager.shared.request(dataRequest) { (result: Result<RunningRecordsResponse, AFError>) in
            switch result {
            case .success(let data):
                print("러닝 기록 조회: \(data)")
                completion(data)
            case .failure(let error):
                print("\(error)")
            }
        }
    }
}



