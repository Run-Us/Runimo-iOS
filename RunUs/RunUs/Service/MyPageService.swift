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
    let keychain = KeychainSwift()
    let baseUrl = "http://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")/users"
    
    // 마이페이지 메인 조회
    func getMyPage(completion: @escaping (MyPage) -> Void) {
        let url = "\(baseUrl)/my?runningPage=\(0)&runningSize=\(3)"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        let dataRequest = AF.request(url, method: .get, encoding: URLEncoding.default, headers: headers)
        
        dataRequest.responseDecodable(of: BaseResponse<MyPage>.self) { response in
            switch response.result {
            case .success(let response):
                if let data = response.payload {
                    completion(data)
                }
            case .failure(let error):
                print("getMyPage Failed: \(error)")
            }
        }
    }
    
    // 특정 기간 나의 통계 조회
    func getMyRunningData(type: String, startDate: String, endDate: String, completion: @escaping (_ data: RunningGraph) -> Void) {
        let url = "\(baseUrl)/my/stats?type=\(type)&startDate=\(startDate)&endDate=\(endDate)"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        AF.request(url, method: .get, encoding: URLEncoding.default, headers: headers)
            .responseDecodable(of: BaseResponse<RunningGraph>.self) { response in
                print(String(decoding: response.data ?? Data(), as: UTF8.self))
                switch response.result {
                case .success(let response):
                    print(response)
                    if let data = response.payload {
                        completion(data)
                    }
                case .failure(let error):
                    print("getMyPage Failed: \(error)")
                }
            }
    }
}
