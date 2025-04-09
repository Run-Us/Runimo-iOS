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
    
    // 애정 주기
    func patchLovePoint(eggId: Int, amount: Int) {
        let path = "/users/eggs/\(eggId)"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        let parameters: [String: Any] = [
            "love_point_amount": amount
        ]
        
        let dataRequest = APIRequest(path: path, method: .patch, parameters: parameters, headers: headers)
        
        NetworkManager.shared.request(dataRequest) { (result: Result<PatchLovePointResponse, AFError>) in
            switch result {
            case .success(let data):
                print("\(data)")
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    // 보유 중인 알 조회
    func getMyEggs(completion: @escaping (GetMyEggs) -> Void) {
        let path = "/users/eggs"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        let dataRequest = APIRequest(path: path, method: .get, encoding: URLEncoding.default, headers: headers)
        
        NetworkManager.shared.request(dataRequest) { (result: Result<GetMyEggs, AFError>) in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print("\(error)")
            }
        }
          
    }
    
    // 알 등록
    func postEgg(egg_id: Int) {
        let path = "/users/eggs"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        let parameters: [String: Any] = [
            "item_id": egg_id
        ]
        
        let dataRequest = APIRequest(path: path, method: .post, parameters: parameters, headers: headers)
        
        NetworkManager.shared.request(dataRequest) { (result: Result<PostEggResponse, AFError>) in
            switch result {
            case .success(let data):
                print("\(data)")
            case .failure(let error):
                print("\(error)")
            }
        }
    }
}
