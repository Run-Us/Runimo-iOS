//
//  MyPageService.swift
//  RunUs
//
//  Created by 가은 on 11/20/24.
//

import Alamofire
import Foundation
import KeychainSwift

class MyPageService {
    static let shared = MyPageService()
    let keychain = KeychainSwift()
    let baseUrl = "https://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")/users"
    
    private init() { }
    
    // 마이페이지 메인 조회
    func getMyPage(completion: @escaping (MyPage) -> Void) {
        let path = "/users/me"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        let dataRequest = APIRequest(path: path, method: .get, encoding: URLEncoding.default, headers: headers)
        
        NetworkManager.shared.request(dataRequest) { (result: Result<MyPage, AFError>) in
            switch result {
            case .success(let data):
                print("\(data)")
                completion(data)
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    // 주간 통계 조회
    func getWeeklyRunningRecords(startDate: String, endDate: String, completion: @escaping (_ data: RunningRecordResponse) -> Void) {
        let path = "/records/stats/weekly"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        let parameters: [String: Any] = [
            "startDate": startDate,
            "endDate": endDate
        ]
        
        let dataRequest = APIRequest(path: path, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        
        NetworkManager.shared.request(dataRequest) { (result: Result<RunningRecordResponse, AFError>) in
            switch result {
            case .success(let data):
                print("\(data)")
                completion(data)
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    // 월간 통계 조회
    func getMonthlyRunningRecords(year: Int, month: Int, completion: @escaping (_ data: RunningRecordResponse) -> Void) {
        let path = "/records/stats/monthly"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        let parameters: [String: Any] = [
            "year": year,
            "month": month
        ]
        
        let dataRequest = APIRequest(path: path, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        
        NetworkManager.shared.request(dataRequest) { (result: Result<RunningRecordResponse, AFError>) in
            switch result {
            case .success(let data):
                print("\(data)")
                completion(data)
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    // 탈퇴하기
    func withdrawUser(reason: String, inputText: String, completion: @escaping (Bool) -> Void) {
        let path = "/users"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        let parameters: [String: Any] = [
            "withdraw_reason": reason,
            "reason_detail": inputText
        ]
        
        let dataRequest = APIRequest(path: path, method: .delete, parameters: parameters, headers: headers)
        
        NetworkManager.shared.getHTTPStatusCode(dataRequest) { code in
            if code == 204 {
                print("탈퇴 성공")
                completion(true)
            } else {
                completion(false)
            }
        }
        
    }
}
