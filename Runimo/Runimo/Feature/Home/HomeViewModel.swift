//
//  HomeViewModel.swift
//  Runimo
//
//  Created by 가은 on 10/13/25.
//

import Alamofire
import Combine

class HomeViewModel: ObservableObject {
    @Published var egg_love: (egg: Int, love: Int) = (0, 0)
    @Published var homeData: HomeItem?
    @Published var isHomeDataLoaded: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchHome() {
        HomeService.shared.getHome()
            .sink(receiveCompletion: handleCompletion) { [weak self] homeItem in
                self?.homeData = homeItem
                self?.egg_love = (homeItem.user_info.total_egg_count, homeItem.user_info.love_point)
                self?.isHomeDataLoaded = true
            }
            .store(in: &cancellables)
    }
    
    /// Comine 완료 이벤트 처리 메서드
    private func handleCompletion(_ completion: Subscribers.Completion<AFError>) {
        if case .failure(let error) = completion {
            print("❌ Error: \(error)")
        }
    }
}
