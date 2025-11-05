//
//  CharacterViewModel.swift
//  Runimo
//
//  Created by 가은 on 11/5/25.
//

import Foundation

@MainActor
class CharacterViewModel: ObservableObject {
    
    // 의존성 주입
    private let runimoService: RunimoServiceProtocol
    
    init(runimoService: RunimoServiceProtocol = RunimoService.shared) {
        self.runimoService = runimoService
    }
    
    /// 전체 러니모 데이터 가져오기
    func getAllRunimos(completion: @escaping (GetAllRunimo) -> Void) {
        Task {
            do {
                let data = try await runimoService.getAllRunimos()
                completion(data)
            } catch {
                handleError(error)
            }
        }
    }
    
    /// 내가 보유한 러니모 데이터 가져오기
    func getMyRunimo(completion: @escaping (GetMyRunimo) -> Void) {
        Task {
            do {
                let data = try await runimoService.getMyRunimo()
                completion(data)
            } catch {
                handleError(error)
            }
        }
    }
}
