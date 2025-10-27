//
//  RunningSessionService.swift
//  RunUs
//
//  Created by byeoungjik on 9/30/24.
//

import Foundation
import CoreLocation
import Alamofire
import Combine

// MARK: - RunningServiceProtocol
protocol RunningServiceProtocol {
    func saveRunningRecords(running: RunningResult) async throws -> SaveRunningResponse
    func getRunningReward(runningId: String) async throws -> RewardResponse
    func getMyRunningRecords(page: Int, selectedDate: Date) async throws -> RunningRecordsResponse
    func getRunningDetail(runningId: String) async throws -> RunningPostResponse
}

class RunningService: RunningServiceProtocol {
    static let shared = RunningService()
    let baseUrl = "https://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"
    
    private let networkManager: NetworkManagerProtocol
    
    private init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    /// 러닝 기록 저장
    func saveRunningRecords(running: RunningResult) async throws -> SaveRunningResponse {
        let path = "/records"
        
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
        
        return try await networkManager.request(
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
    func getRunningReward(runningId: String) async throws -> RewardResponse {
        let path = "/rewards/runnings"
        
        let parameters: [String: Any] = [
            "record_id": runningId
        ]
        
        return try await networkManager.request(
            APIRequest(
                path: path,
                method: .post,
                parameters: parameters
            )
        )
    }
    
    func getMyRunningRecords(page: Int, selectedDate: Date) async throws -> RunningRecordsResponse {
        let path = "/records/me"
        
        let (startDate, endDate) = DateManager.shared.currentMonthFirstAndLastDateString(date: selectedDate)
        
        let parameters: [String: Any] = [
            "page": page,
            "size": 10,
            "startDate": startDate,
            "endDate": endDate
        ]
        
        return try await networkManager.request(
            APIRequest(
                path: path,
                method: .get,
                parameters: parameters,
                encoding: URLEncoding.default
            )
        )
    }
    
    /// 러닝 상세 조회
    func getRunningDetail(runningId: String) async throws -> RunningPostResponse {
        let path = "/records/\(runningId)"
        
        return try await networkManager.request(
            APIRequest(
                path: path,
                method: .get,
                encoding: URLEncoding.default
            )
        )
    }
}



