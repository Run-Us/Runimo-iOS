//
//  HomePage.swift
//  RunUs
//
//  Created by byeoungjik on 9/9/24.
//

import SwiftUI
import Kingfisher

struct HomeTab: View {
    @EnvironmentObject var sharedData: SharedData
    @State private var eggId: Int = 0
    @State private var eggCode: String = ""
    @State private var source: LottieSource = .asset(name: "", mode: .loop)
    @State private var reloadID = UUID()
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.primaryBG
            GeometryReader { geometry in
                VStack(spacing: 24) {
                    Button {
                        sharedData.currentMainTab = .character
                    } label: {
                        characterProfile()
                    }
                    eggCard()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 24)
            }
        }
        .onAppear {
            getHomeAPI()
        }
        .onChange(of: sharedData.updateHomeView) { _, _ in
            getHomeAPI()
        }
    }

    @ViewBuilder
    private func characterProfile() -> some View {
        HStack(spacing: 46) {
            if sharedData.isHomeDataLoaded && sharedData.homeData?.main_runimo_stat_nullable == nil {
                Image("character_disabled")
                    .resizable()
                    .frame(width: 86, height: 86)
            } else {
                KFImage(URL(string: sharedData.homeData?.main_runimo_stat_nullable?.image_url ?? ""))
                    .placeholder { ProgressView() }
                    .resizable()
                    .frame(width: 86, height: 86)
            }
                
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("\(sharedData.homeData?.main_runimo_stat_nullable?.name ?? "알을 부화시켜보세요!")")
                        .foregroundStyle(.primaryGray)
                        .font(.title5_bold)
                    Spacer()
                }
                HStack(spacing: 40) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("러닝")
                            .font(.caption_regular)
                            .foregroundStyle(.quaternaryGray)
                        Text("\(sharedData.homeData?.main_runimo_stat_nullable?.total_running_count ?? 0)")
                            .font(.title5_bold)
                            .foregroundStyle(.primaryGray)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("달린 거리")
                            .font(.caption_regular)
                            .foregroundStyle(.quaternaryGray)
                        Text(String(format: "%.2f km", Double(sharedData.homeData?.main_runimo_stat_nullable?.total_distance_in_meters ?? 0)/1000))
                            .font(.title5_bold)
                            .foregroundStyle(.primaryGray)
                            .minimumScaleFactor(0.8)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.primaryFill)
                .stroke(.secondaryFill, lineWidth: 1)
        )
    }
    
    @ViewBuilder
    private func eggCard() -> some View {
        VStack(spacing: 12) {
            if sharedData.isHomeEggDataLoaded && sharedData.homeEggData == nil {
                Image("egg_default")
            } else {
                if eggCode == "" {
                    ProgressView()
                } else {
                    LottieView(source: source, reloadID: reloadID)
                        .frame(width: 310, height: 280)
                }
            }
            
            if let egg = sharedData.homeEggData {
                HStack {
                    Text(egg.name)
                        .font(.title5_bold)
                        .foregroundStyle(.primaryGray)
                    Spacer()
                    Text("\(egg.current_love_point_amount)/\(egg.hatch_required_point_amount)")
                        .font(.caption_regular)
                        .foregroundStyle(.quaternaryGray)
                }
                .padding(.bottom, 12)
                
                ProgressBar(progress: Double(egg.current_love_point_amount)/Double(egg.hatch_required_point_amount))
                
                giveLoveButton(isHatchable: egg.hatchable)
            } else {
                HStack {
                    Text("새 알을 기다리는 중이에요")
                        .font(.title5_bold)
                        .foregroundStyle(.primaryGray)
                    Spacer()
                }
                .padding(.bottom, 12)
                
                registerEgg()
            }
            
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.primaryFill)
                .stroke(.secondaryFill, lineWidth: 1)
        )
    }
    
    @ViewBuilder
    private func giveLoveButton(isHatchable: Bool) -> some View {
        Button {
            if isHatchable {
                // 부화하기
                hatchEggAPI(eggId: eggId)
            } else {
                // 애정주기
                if eggId >= 0 {
                    HomeService.shared.patchLovePoint(eggId: eggId, amount: 1) { response in
                        // Lottie
                        source = .asset(name: "\(eggCode)-04-\(Int.random(in: 1...2))-애정", mode: .playOnce)
                        reloadID = UUID()   // 로띠 reload 유도
                        
                        sharedData.homeEggData?.current_love_point_amount = response.current_love_point_amount
                        
                        DispatchQueue.main.async {
                            getHomeAPI()
                        }
                    }
                }
            }
        } label: {
            HStack(spacing: 8) {
                Image(isHatchable ? "icon_egg" : "icon_love")
                Text(isHatchable ? "알 부화하기" : "애정 주기")
                    .font(.title5_bold)
                    .foregroundStyle(.primaryGray)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 18)
            .frame(maxWidth: .infinity)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.primaryBG)
                .stroke(.secondaryFill, lineWidth: 1)
        )
    }
    
    @ViewBuilder
    private func registerEgg() -> some View {
        Button {
            sharedData.showEggSheet = true
        } label: {
            HStack(spacing: 8) {
                Text("알 등록하기")
                    .font(.title5_bold)
                    .foregroundStyle(.white)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 18)
            .frame(maxWidth: .infinity)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.primary400)
        )
    }
    
    private func getHomeAPI() {
        HomeService.shared.getHome { item in
            DispatchQueue.main.async {
                sharedData.homeData = item
                sharedData.egg_love = (item.user_info.total_egg_count, item.user_info.love_point)
                
                sharedData.isHomeDataLoaded = true
            }
        }
        
        getHomeEggAPI()
    }
    
    private func getHomeEggAPI() {
        HomeService.shared.getCurrentEgg { egg in
            DispatchQueue.main.async {
                sharedData.homeEggData = egg.incubating_eggs.first
                eggId = egg.incubating_eggs.first?.id ?? -1
                eggCode = String(egg.incubating_eggs.first?.egg_code.dropFirst() ?? "")
                source = .asset(name: "\(eggCode)-03-빛남", mode: .loop)
                
                sharedData.isHomeEggDataLoaded = true
            }
        }
    }
    
    private func hatchEggAPI(eggId: Int) {
        HomeService.shared.hatchEgg(eggId: eggId) { data in
            sharedData.currentHatchedEgg = data
            sharedData.isHatchable = true
            sharedData.showPopUp(isEgg: false)
            getHomeAPI()
        }
    }
}

#Preview {
    HomeTab()
        .environmentObject(MyPageViewModel())
}
