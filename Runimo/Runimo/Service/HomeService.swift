//
//  HomeService.swift
//  Runimo
//
//  Created by 가은 on 4/2/25.
//

import Alamofire
import Foundation
import KeychainSwift

class HomeService {
    static let shared = HomeService()
    let keychain = KeychainSwift()
    let baseUrl = "https://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"
    
    private init() { }
    
    func getHome(completion: @escaping (HomeItem) -> Void) {
        let url = "\(baseUrl)/main"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        AF.request(url, method: .get, encoding: URLEncoding.default, headers: headers)
            .responseDecodable(of: BaseResponse<HomeItem>.self) { response in
                print(String(decoding: response.data ?? Data(), as: UTF8.self))
                switch response.result {
                case .success(let response):
                    print("getHome data: ", response)
                    if let data = response.payload {
                        completion(data)
                    }
                case .failure(let error):
                    print("getHome Failed: \(error)")
                }
            }
    }
}
