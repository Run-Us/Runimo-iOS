//
//  MyPageService.swift
//  RunUs
//
//  Created by 가은 on 11/20/24.
//

import Alamofire
import Foundation
import Combine

class MyPageService {
    static let shared = MyPageService()
    let baseUrl = "https://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")/users"
    
    private let networkManager: NetworkManagerProtocol
    
    private init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    /// 마이페이지 메인 조회
    func getMyPage() -> AnyPublisher<MyPage, AFError> {
        let path = "/users/me"
        
        return networkManager.request(
            APIRequest(
                path: path,
                method: .get,
                encoding: URLEncoding.default
            )
        )
    }
    
    /// 주간 통계 조회
    func getWeeklyRunningRecords(startDate: String, endDate: String) -> AnyPublisher<RunningRecordResponse, AFError> {
        let path = "/records/stats/weekly"
        
        let parameters: [String: Any] = [
            "startDate": startDate,
            "endDate": endDate
        ]
        
        return networkManager.request(
            APIRequest(
                path: path,
                method: .get,
                parameters: parameters,
                encoding: URLEncoding.default
            )
        )
    }
    
    /// 월간 통계 조회
    func getMonthlyRunningRecords(year: Int, month: Int) -> AnyPublisher<RunningRecordResponse, AFError> {
        let path = "/records/stats/monthly"
        
        let parameters: [String: Any] = [
            "year": year,
            "month": month
        ]
        
        return networkManager.request(
            APIRequest(
                path: path,
                method: .get,
                parameters: parameters,
                encoding: URLEncoding.default
            )
        )
    }
    
    // 탈퇴하기
    func withdrawUser(reason: String, inputText: String, completion: @escaping (Bool) -> Void) {
        let path = "/users"
        
        let parameters: [String: Any] = [
            "withdraw_reason": reason,
            "reason_detail": inputText
        ]
        
        let dataRequest = APIRequest(path: path, method: .delete, parameters: parameters)
        
        networkManager.getHTTPStatusCode(dataRequest) { code in
            if code == 204 {
                print("탈퇴 성공")
                completion(true)
            } else {
                completion(false)
            }
        }
        
    }
    
    func sendFeedback(rate: Int, contents: String, completion: @escaping (Bool) -> Void) {
        let path = "/feedback"
        
        let parameters: [String: Any] = [
            "rate": rate,
            "feedback": contents
        ]
        
        let dataRequest = APIRequest(path: path, method: .post, parameters: parameters)
        
        networkManager.getHTTPStatusCode(dataRequest) { code in
            if code == 201 {
                print("피드백 보내기 성공")
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
