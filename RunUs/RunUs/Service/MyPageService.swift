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
}
