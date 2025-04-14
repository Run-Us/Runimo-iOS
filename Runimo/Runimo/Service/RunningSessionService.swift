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
    let keychain = KeychainSwift()
    let baseUrl = "http://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"
    let idToken = UserDefaults.standard.integer(forKey: "idToken")
    
    // 달리기 기록 저장
    func postAggregate(mode: String, runningId: String?, distance: Int, runningTime: Int, pace: Int) {
        let url = "\(baseUrl)/runnings/aggregates?mode=\(mode)"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        var parameters: [String: Any] = [
            "recordData": "",    // TODO: 압축한 문자열
            "runningDistanceInMeters": distance,
            "runningDurationInMilliSeconds": runningTime,
            "averagePaceInMilliSeconds": pace
        ]
        
        // 그룹 달리기만 runningId 추가
        if let runningId = runningId {
            parameters.updateValue(runningId, forKey: "runningId")
        }
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: BaseResponse<String>.self) { response in
                switch response.result {
                case .success(let response):
                    print("Aggregate Success: \(response)")
                case .failure(let error):
                    print("Aggregate Failed: \(error)")
                }
            }
    }
}



