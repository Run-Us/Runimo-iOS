//
//  HomeService.swift
//  Runimo
//
//  Created by 가은 on 4/2/25.
//

import Alamofire
import Foundation
import Combine

// MARK: - HomeServiceProtocol
protocol HomeServiceProtocol {
    func getHome() async throws -> HomeItem
    func getCurrentEgg() async throws -> HomeEggResponse
    func giveLovePoint(eggId: Int, amount: Int) async throws -> PatchLovePointResponse
    func getMyEggs() async throws -> GetMyEggs
}

class HomeService: HomeServiceProtocol {
    static let shared = HomeService()
    
    private let networkManager: NetworkManagerProtocol
    
    private init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func getHome() async throws -> HomeItem {
        let path = "/main"
        
        return try await networkManager.request(
            APIRequest(
                path: path,
                method: .get,
                encoding: URLEncoding.default
            )
        )
    }
    
    /// 부화중인 알 조회
    func getCurrentEgg() async throws -> HomeEggResponse {
        let path = "/users/eggs/incubators"
        
        return try await networkManager.request(
            APIRequest(
                path: path,
                method: .get,
                encoding: URLEncoding.default
            )
        )
    }
    
    /// 애정 주기
    func giveLovePoint(eggId: Int, amount: Int) async throws -> PatchLovePointResponse {
        let path = "/users/eggs/\(eggId)"
        
        let parameters: [String: Any] = [
            "love_point_amount": amount
        ]
        
        return try await networkManager.request(
            APIRequest(
                path: path,
                method: .patch,
                parameters: parameters
            )
        )
    }
    
    /// 보유 중인 알 조회
    func getMyEggs() async throws -> GetMyEggs {
        let path = "/users/eggs"

        return try await networkManager.request(
            APIRequest(
                path: path,
                method: .get,
                encoding: URLEncoding.default
            )
        )
    }
    
    // 알 등록
    func postEgg(egg_id: Int, completion: @escaping () -> Void) {
        let path = "/users/eggs"
        
        let parameters: [String: Any] = [
            "item_id": egg_id
        ]
        
        let dataRequest = APIRequest(path: path, method: .post, parameters: parameters)
        
        networkManager.request(dataRequest) { (result: Result<PostEggResponse, AFError>) in
            switch result {
            case .success(let data):
                print("\(data)")
                completion()
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    // 알 부화
    func hatchEgg(eggId: Int, completion: @escaping (HatchEggResponse) -> Void) {
        let path = "/incubating-eggs/\(eggId)/hatch"
        
        let dataRequest = APIRequest(path: path, method: .post)
        
        networkManager.request(dataRequest) { (result: Result<HatchEggResponse, AFError>) in
            switch result {
            case .success(let data):
                print("\(data)")
                completion(data)
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    func setMainRunimo(runimoId: Int, completion: @escaping () -> Void) {
        let path = "/runimos/\(runimoId)/main"
        
        let dataRequest = APIRequest(path: path, method: .patch)
        
        networkManager.request(dataRequest) { (result: Result<RunimoIdResponse, AFError>) in
            switch result {
            case .success(let data):
                print("\(data)")
                completion()
            case .failure(let error):
                print("\(error)")
            }
        }
    }
}
