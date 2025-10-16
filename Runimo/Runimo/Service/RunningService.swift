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
import Combine

class RunningService: ObservableObject {
    static let shared = RunningService()
    let keychain = KeychainSwift()
    let baseUrl = "https://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"
    
    private let networkManager: NetworkManagerProtocol
    
    private init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    /// 러닝 기록 저장
    func saveRunningRecords(running: RunningResult) -> AnyPublisher<SaveRunningResponse, AFError> {
        let path = "\(baseUrl)/records"
        
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
        
        return networkManager.request(
            APIRequest(
                path: path,
                method: .post,
                parameters: parameters
            )
        )
    }
    
    /// 러닝 기록 수정
    func patchRunningRecords(runningId: String, title: String, description: String, imgURL: String) -> AnyPublisher<Int, AFError> {
        let path = "/records/\(runningId)"
        
        let parameters: [String: Any] = [
            "title": title,
            "description": description,
            "img_url": imgURL
        ]
        
        return networkManager.getHTTPStatusCode(
            APIRequest(
                path: path,
                method: .patch,
                parameters: parameters
            )
        )
    }
    
    /// 러닝 보상 획득
    func getRunningReward(runningId: String) -> AnyPublisher<RewardResponse, AFError> {
        let path = "/rewards/runnings"
        
        let parameters: [String: Any] = [
            "record_id": runningId
        ]
        
        return networkManager.request(
            APIRequest(
                path: path,
                method: .post,
                parameters: parameters
            )
        )
    }
    
    func getMyRunningRecords(page: Int, selectedDate: Date, completion: @escaping (RunningRecordsResponse) -> Void) {
        let path = "/records/me"
        
        let (startDate, endDate) = DateManager.shared.currentMonthFirstAndLastDateString(date: selectedDate)
        
        let parameters: [String: Any] = [
            "page": page,
            "size": 10,
            "startDate": startDate,
            "endDate": endDate
        ]
        
        let dataRequest = APIRequest(path: path, method: .get, parameters: parameters, encoding: URLEncoding.default)

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
        
        let dataRequest = APIRequest(path: path, method: .get, encoding: URLEncoding.default)

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
    
    /// 러닝 상세 조회
    func getRunningDetail(runningId: String) -> AnyPublisher<RunningPostResponse, AFError> {
        let path = "/records/\(runningId)"
        
        return networkManager.request(
            APIRequest(
                path: path,
                method: .get,
                encoding: URLEncoding.default
            )
        )
    }
}



