//
//  RunimoService.swift
//  Runimo
//
//  Created by 가은 on 4/14/25.
//

import Alamofire
import Foundation
import KeychainSwift

class RunimoService {
    static let shared = RunimoService()
    private let keychain = KeychainSwift()
    
    func getAllRunimos(completion: @escaping (GetAllRunimo) -> Void) {
        let path = "/runimos/types/all"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        let dataRequest = APIRequest(path: path, method: .get, headers: headers)
        
        NetworkManager.shared.getHTTPStatusCode(dataRequest) { code in
            
        }
        
        NetworkManager.shared.request(dataRequest) { (result: Result<GetAllRunimo, AFError>) in
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
