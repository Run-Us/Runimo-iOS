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
    let baseUrl = "https://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"
    
    private let networkManager: NetworkManagerProtocol
    
    private init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func saveRunningRecords(running: RunningResult, retrying: Bool = false, completion: @escaping (Bool, String) -> Void) {
        let path = "\(baseUrl)/records"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        let parameters: [String: Any] = [
            "started_at": DateManager.shared.getString(date: running.started_at),
            "end_at": DateManager.shared.getString(date: running.end_at),
            "total_distance_in_meters": running.total_distance_in_meters ?? 0,
            "average_pace_in_milli_seconds": running.average_pace_in_milli_seconds ?? 0,
            "total_time_in_seconds": running.total_time_in_seconds ?? 0,
            "segment_paces": (running.segment_paces ?? []).map {
                return [
                    "distance": $0.distance,
                    "pace": $0.pace
                ]
            }
        ]
        
        let dataRequest = APIRequest(path: path, method: .post, parameters: parameters, headers: headers)
        
        networkManager.request(dataRequest) { (result: Result<SaveRunningResponse, AFError>) in
            switch result {
            case .success(let data):
                print("runningId: \(data.saved_id)")
                completion(true, data.saved_id)
            case .failure(let error):
                print("❌ Request Failed: Request URL: \(path)\n\(error.localizedDescription)")
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
        networkManager.getHTTPStatusCode(dataRequest) { result in
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
        
        networkManager.request(dataRequest) { (result: Result<RewardResponse, AFError>) in
            switch result {
            case .success(let data):
                print("러닝 보상 획득: \(data)")
                completion(data)
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    func getMyRunningRecords(page: Int, selectedDate: Date, completion: @escaping (RunningRecordsResponse) -> Void) {
        let path = "/records/me"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        let (startDate, endDate) = DateManager.shared.currentMonthFirstAndLastDateString(date: selectedDate)
        
        let parameters: [String: Any] = [
            "page": page,
            "size": 10,
            "startDate": startDate,
            "endDate": endDate
        ]
        
        let dataRequest = APIRequest(path: path, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)

        networkManager.request(dataRequest) { (result: Result<RunningRecordsResponse, AFError>) in
            switch result {
            case .success(let data):
                print("러닝 기록 조회: \(data)")
                completion(data)
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    func getRunningPostData(runningId: String, completion: @escaping (RunningPostResponse) -> Void) {
        let path = "/records/\(runningId)"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        let dataRequest = APIRequest(path: path, method: .get, encoding: URLEncoding.default, headers: headers)

        networkManager.request(dataRequest) { (result: Result<RunningPostResponse, AFError>) in
            switch result {
            case .success(let data):
                print("러닝 post 조회: \(data)")
                completion(data)
            case .failure(let error):
                print("\(error)")
            }
        }
    }
}



