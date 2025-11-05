//
//  RunimoService.swift
//  Runimo
//
//  Created by 가은 on 4/14/25.
//

import Alamofire
import Foundation

// MARK: - RunimoServiceProtocol
protocol RunimoServiceProtocol {
    func getAllRunimos() async throws -> GetAllRunimo
    func getMyRunimo() async throws -> GetMyRunimo
}

// MARK: - RunimoService
class RunimoService: RunimoServiceProtocol {
    static let shared = RunimoService()
    
    private let networkManager: NetworkManagerProtocol
    
    private init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    /// 전체 러니모 조회
    func getAllRunimos() async throws -> GetAllRunimo {
        let path = "/runimos/types/all"
        
        return try await networkManager.request(
            APIRequest(
                path: path,
                method: .get
            )
        )
    }
    
    /// 내가 보유한 러니모 조회
    func getMyRunimo() async throws -> GetMyRunimo {
        let path = "/users/me/runimos"
        
        return try await networkManager.request(
            APIRequest(
                path: path,
                method: .get
            )
        )
    }
}
