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
    let baseUrl = "http://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")/users"
    
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
    
    // 탈퇴하기
    func withdrawUser() {
        let path = "/users"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        let dataRequest = APIRequest(path: path, method: .delete, headers: headers)
        
        NetworkManager.shared.getHTTPStatusCode(dataRequest) { code in
            if code == 204 {
                print("탈퇴 성공")
                // TODO: 첫 화면으로 이동하기 
            }
        }
        
    }
}
