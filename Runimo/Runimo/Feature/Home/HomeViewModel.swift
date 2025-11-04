//
//  HomeViewModel.swift
//  Runimo
//
//  Created by 가은 on 10/13/25.
//

import Foundation

@MainActor
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

    /// 보유 중인 알
    @Published var myEggs: [EggItem] = []
    
    /// 홈 화면 업데이트 flag
    @Published var updateHomeFlag: Bool = false

    // 의존성 주입
    private let homeService: HomeServiceProtocol
    
    init(homeService: HomeServiceProtocol = HomeService.shared) {
        self.homeService = homeService
    }
    
    // MARK: - API 호출 Methods
    /// 홈 데이터 조회 API 호출
    func fetchHome() {
        Task {
            do {
                let homeItem = try await homeService.getHome()
                
                self.homeData = homeItem
                self.egg_love = (homeItem.user_info.total_egg_count, homeItem.user_info.love_point)
                self.isHomeDataLoaded = true
            } catch {
                print("❌ Error: \(error)")
            }
        }
    }
    
    /// 부화중인 알 조회 API 호출
    func fetchCurrentEgg() {
        Task {
            do {
                let egg = try await homeService.getCurrentEgg()

                self.homeEggData = egg.incubating_eggs.first
                self.eggId = egg.incubating_eggs.first?.id ?? -1
                self.eggCode = String(self.homeEggData?.egg_code.dropFirst() ?? "")

                var lottieName = ""
                if self.homeEggData?.hatchable ?? false {
                    lottieName = "\(self.eggCode)-04-\(Int.random(in: 1...2))-애정"
                } else {
                    lottieName = "\(self.eggCode)-03-빛남"
                }
                self.eggSource = .asset(name: lottieName, mode: .loop)
                self.isHomeEggDataLoaded = true
            } catch {
                print("❌ Error: \(error)")
            }
        }
    }
    
    /// 애정 주기 API 호출
    func giveLovePoint() {
        Task {
            do {
                let data = try await homeService.giveLovePoint(eggId: eggId, amount: 1)

                // UI 업데이트
                self.eggSource = .asset(name: "\(self.eggCode)-04-\(Int.random(in: 1...2))-애정", mode: .playOnce)
                self.reloadID = UUID()   // 로띠 reload 유도
                self.homeEggData?.current_love_point_amount = data.current_love_point_amount

                // 데이터 새로고침
                self.fetchHome()
                self.fetchCurrentEgg()
            } catch {
                print("❌ Error: \(error)")
            }
        }
    }
    
    /// 보유중인 알 조회 API 호출
    func getMyEggs() {
        Task {
            do {
                let data = try await homeService.getMyEggs()
                self.myEggs = data.items
            } catch {
                print("❌ Error: \(error)")
            }
        }
    }
    
    /// 알 등록 API 호출 
    func registerEgg(eggId: Int) {
        Task {
            do {
                let _ = try await homeService.postEgg(eggId: eggId)
                self.updateHomeFlag.toggle()
            } catch {
                print("❌ Error: \(error)")
            }
        }
    }
    
    /// 알 부화 API 호출
    func hatchEgg(eggId: Int, completion: @escaping (HatchEggResponse) -> Void) {
        Task {
            do {
                let data = try await homeService.hatchEgg(eggId: eggId)
                completion(data)
            } catch {
                print("❌ Error: \(error)")
            }
        }
    }
    
    /// 대표 러니모 설정 API 호출
    func setMainRunimo(runimoId: Int, completion: @escaping () -> Void) {
        Task {
            do {
                try await homeService.setMainRunimo(runimoId: runimoId)
                self.updateHomeFlag.toggle()
            } catch {
                print("❌ Error: \(error)")
            }
        }
    }
}
