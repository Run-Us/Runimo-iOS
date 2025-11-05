//
//  SettingViewModel.swift
//  Runimo
//
//  Created by 가은 on 10/16/25.
//

import Foundation
import Combine
import Alamofire

@MainActor
class SettingViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
    }
    
    /// 로그아웃 API 호출 
    func logout(completion: @escaping () -> Void) {
        Task {
            do {
                try await authService.logout()
                completion()
            } catch {
                handleError(error)
            }
        }
    }
}
