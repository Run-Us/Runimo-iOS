//
//  RunimoService.swift
//  Runimo
//
//  Created by 가은 on 4/14/25.
//

import Alamofire
import Foundation

class RunimoService {
    static let shared = RunimoService()
    
    private let networkManager: NetworkManagerProtocol
    
    private init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    // 전체 러니모 조회
    func getAllRunimos(completion: @escaping (GetAllRunimo) -> Void) {
        let path = "/runimos/types/all"
        
        let dataRequest = APIRequest(path: path, method: .get)
        
        networkManager.request(dataRequest) { (result: Result<GetAllRunimo, AFError>) in
            switch result {
            case .success(let data):
                print("\(data)")
                completion(data)
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    func getMyRunimo(completion: @escaping (GetMyRunimo) -> Void) {
        let path = "/users/me/runimos"
        
        let dataRequest = APIRequest(path: path, method: .get)
        
        networkManager.request(dataRequest) { (result: Result<GetMyRunimo, AFError>) in
            switch result {
            case .success(let data):
                print("\(data)")
                completion(data)
            case .failure(let error):
                print("\(error)")
            }
        }
    }
}
