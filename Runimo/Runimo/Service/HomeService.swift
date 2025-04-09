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
    
    private init() { }
    
    func getHome(completion: @escaping (HomeItem) -> Void) {
        let path = "/main"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        let dataRequest = APIRequest(path: path, method: .get, encoding: URLEncoding.default, headers: headers)
        
        NetworkManager.shared.request(dataRequest) { (result: Result<HomeItem, AFError>) in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print("\(error)")
            }
        }
        
    }
    
    // 부화중인 알 조회
    func getCurrentEgg(completion: @escaping (HomeEggResponse) -> Void) {
        let path = "/users/eggs/incubators"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        let dataRequest = APIRequest(path: path, method: .get, encoding: URLEncoding.default, headers: headers)
        
        NetworkManager.shared.request(dataRequest) { (result: Result<HomeEggResponse, AFError>) in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print("\(error)")
            }
        }

    }
}
