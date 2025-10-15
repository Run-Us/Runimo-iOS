//
//  SettingViewModel.swift
//  Runimo
//
//  Created by 가은 on 10/16/25.
//

import Foundation
import Combine
import Alamofire

class SettingViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    func logout(completion: @escaping (Bool) -> Void) {
        AuthService.shared.logout()
            .sink(receiveCompletion: handleCompletion) { response in
                completion(response)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    /// Comine 완료 이벤트 처리 메서드
    private func handleCompletion(_ completion: Subscribers.Completion<AFError>) {
        if case .failure(let error) = completion {
            print("❌ Error: \(error)")
        }
    }
}
