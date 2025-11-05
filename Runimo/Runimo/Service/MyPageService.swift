//
//  MyPageService.swift
//  RunUs
//
//  Created by 가은 on 11/20/24.
//

import Alamofire
import Foundation
import Combine

protocol MyPageServiceProtocol {
    func getMyPage() async throws -> MyPage
    func getWeeklyRunningRecords(startDate: String, endDate: String) async throws -> RunningRecordResponse
    func getMonthlyRunningRecords(year: Int, month: Int) async throws -> RunningRecordResponse
    func withdrawUser(reason: String, inputText: String) async throws
    func sendFeedback(rate: Int, contents: String) async throws
}

class MyPageService: MyPageServiceProtocol {
    static let shared = MyPageService()
    
    private let networkManager: NetworkManagerProtocol
    
    private init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    /// 마이페이지 메인 조회
    func getMyPage() async throws -> MyPage {
        let path = "/users/me"
        
        return try await networkManager.request(
            APIRequest(
                path: path,
                method: .get,
                encoding: URLEncoding.default
            )
        )
    }
    
    /// 주간 통계 조회
    func getWeeklyRunningRecords(startDate: String, endDate: String) async throws -> RunningRecordResponse {
        let path = "/records/stats/weekly"
        
        let parameters: [String: Any] = [
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
    
    /// 월간 통계 조회
    func getMonthlyRunningRecords(year: Int, month: Int) async throws -> RunningRecordResponse {
        let path = "/records/stats/monthly"
        
        let parameters: [String: Any] = [
            "year": year,
            "month": month
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
    
    /// 탈퇴하기
    func withdrawUser(reason: String, inputText: String) async throws {
        let path = "/users"

        let parameters: [String: Any] = [
            "withdraw_reason": reason,
            "reason_detail": inputText
        ]

        // NetworkManager의 Void 반환 request 사용
        // 204 No Content가 성공 응답이며, validate()가 2xx를 체크함
        try await networkManager.request(
            APIRequest(
                path: path,
                method: .delete,
                parameters: parameters
            )
        )

        print("✅ 탈퇴 성공")
    }
    
    /// 피드백 보내기
    func sendFeedback(rate: Int, contents: String) async throws {
        let path = "/feedback"

        let parameters: [String: Any] = [
            "rate": rate,
            "feedback": contents
        ]

        // NetworkManager의 Void 반환 request 사용
        // 201 Created가 성공 응답이며, validate()가 2xx를 체크함
        try await networkManager.request(
            APIRequest(
                path: path,
                method: .post,
                parameters: parameters
            )
        )

        print("✅ 피드백 보내기 성공")
    }
}
