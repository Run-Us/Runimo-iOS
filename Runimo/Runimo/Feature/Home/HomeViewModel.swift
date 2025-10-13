//
//  HomeViewModel.swift
//  Runimo
//
//  Created by 가은 on 10/13/25.
//

import Alamofire
import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var egg_love: (egg: Int, love: Int) = (0, 0)
    @Published var homeData: HomeItem?
    @Published var isHomeDataLoaded: Bool = false
    
    @Published var homeEggData: IncubatingEgg?
    @Published var eggId: Int = 0
    @Published var eggCode: String = ""
    @Published var eggSource: LottieSource = .asset(name: "", mode: .loop)
    @Published var isHomeEggDataLoaded: Bool = false
    @Published var reloadID = UUID()
    
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
    
    func fetchCurrentEgg() {
        HomeService.shared.getCurrentEgg()
            .sink(receiveCompletion: handleCompletion) { [weak self] egg in
                // UI 업데이트
                self?.homeEggData = egg.incubating_eggs.first
                self?.eggId = egg.incubating_eggs.first?.id ?? -1
                self?.eggCode = String(self?.homeEggData?.egg_code.dropFirst() ?? "")
                
                var lottieName = ""
                if self?.homeEggData?.hatchable ?? false {
                    lottieName = "\(self?.eggCode ?? "")-04-\(Int.random(in: 1...2))-애정"
                } else {
                    lottieName = "\(self?.eggCode ?? "")-03-빛남"
                }
                self?.eggSource = .asset(name: lottieName, mode: .loop)
                
                self?.isHomeEggDataLoaded = true
            }
            .store(in: &cancellables)
    }
    
    /// 애정 주기 API 호출
    func giveLovePoint() {
        HomeService.shared.giveLovePoint(eggId: eggId, amount: 1)
            .sink(receiveCompletion: handleCompletion) { [weak self] data in
                // UI 업데이트
                self?.eggSource = .asset(name: "\(self?.eggCode ?? "")-04-\(Int.random(in: 1...2))-애정", mode: .playOnce)
                self?.reloadID = UUID()   // 로띠 reload 유도

                self?.homeEggData?.current_love_point_amount = data.current_love_point_amount

                // 데이터 새로고침
                self?.fetchHome()
                self?.fetchCurrentEgg()
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
