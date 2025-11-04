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
    func postEgg(eggId: Int) async throws -> PostEggResponse
    func hatchEgg(eggId: Int) async throws -> HatchEggResponse
    func setMainRunimo(runimoId: Int) async throws
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
    
    /// 알 등록
    func postEgg(eggId: Int) async throws -> PostEggResponse {
        let path = "/users/eggs"
        
        let parameters: [String: Any] = [
            "item_id": eggId
        ]
        
        return try await networkManager.request(
            APIRequest(
                path: path,
                method: .post,
                parameters: parameters
            )
        )
    }
    
    /// 알 부화
    func hatchEgg(eggId: Int) async throws -> HatchEggResponse {
        let path = "/incubating-eggs/\(eggId)/hatch"
        
        return try await networkManager.request(
            APIRequest(
                path: path,
                method: .post
            )
        )
    }
    
    /// 대표 러니모 설정
    func setMainRunimo(runimoId: Int) async throws {
        let path = "/runimos/\(runimoId)/main"
        
        return try await networkManager.request(
            APIRequest(
                path: path,
                method: .patch
            )
        )
    }
}
