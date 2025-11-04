//
//  HomePage.swift
//  RunUs
//
//  Created by byeoungjik on 9/9/24.
//

import SwiftUI
import Kingfisher

struct HomeTab: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var sharedData: SharedData
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.primaryBG
            GeometryReader { geometry in
                VStack(spacing: 24) {
                    Button {
                        sharedData.setTab(.character)
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
            homeVM.fetchHome()
            homeVM.fetchCurrentEgg()
        }
        .onChange(of: sharedData.updateHomeView) { _, _ in
            homeVM.fetchHome()
            homeVM.fetchCurrentEgg()
        }
    }

    @ViewBuilder
    private func characterProfile() -> some View {
        HStack(spacing: 46) {
            if homeVM.isHomeDataLoaded && homeVM.homeData?.main_runimo_stat_nullable == nil {
                Image("character_disabled")
                    .resizable()
                    .frame(width: 86, height: 86)
            } else {
                KFImage(URL(string: homeVM.homeData?.main_runimo_stat_nullable?.image_url ?? ""))
                    .placeholder { ProgressView() }
                    .resizable()
                    .frame(width: 86, height: 86)
            }
                
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("\(homeVM.homeData?.main_runimo_stat_nullable?.name ?? "알을 부화시켜보세요!")")
                        .foregroundStyle(.primaryGray)
                        .font(.title5_bold)
                    Spacer()
                }
                HStack(spacing: 40) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("러닝")
                            .font(.caption_regular)
                            .foregroundStyle(.quaternaryGray)
                        Text("\(homeVM.homeData?.main_runimo_stat_nullable?.total_running_count ?? 0)")
                            .font(.title5_bold)
                            .foregroundStyle(.primaryGray)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("달린 거리")
                            .font(.caption_regular)
                            .foregroundStyle(.quaternaryGray)
                        Text((homeVM.homeData?.main_runimo_stat_nullable?.total_distance_in_meters ?? 0).toDistanceString())
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
            if homeVM.isHomeEggDataLoaded && homeVM.homeEggData == nil {
                Image("egg_default")
            } else {
                if homeVM.eggCode == "" {
                    ProgressView()
                } else {
                    LottieView(source: homeVM.eggSource, reloadID: homeVM.reloadID)
                        .frame(height: 240)
                }
            }
            
            if let egg = homeVM.homeEggData {
                HStack(spacing: 4) {
                    Text(egg.name)
                        .font(.title5_bold)
                        .foregroundStyle(.primaryGray)
                    showTutorialButton()
                    Spacer()
                    Text("\(egg.current_love_point_amount)/\(egg.hatch_required_point_amount)")
                        .font(.caption_regular)
                        .foregroundStyle(.quaternaryGray)
                }
                .padding(.bottom, 12)
                
                ProgressBar(progress: Double(egg.current_love_point_amount)/Double(egg.hatch_required_point_amount))
                
                giveLoveButton(isHatchable: egg.hatchable)
            } else {
                HStack(spacing: 4) {
                    Text("새 알을 기다리는 중이에요")
                        .font(.title5_bold)
                        .foregroundStyle(.primaryGray)
                    
                    showTutorialButton()
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
                hatchEggAPI(eggId: homeVM.eggId)
            } else {
                // 애정주기
                if homeVM.eggId >= 0 {
                    if UserDefaults.standard.object(forKey: "isNotFirstGiveLove") == nil {
                        sharedData.showTutorial1Sheet = true
                    } else {
                        homeVM.giveLovePoint()
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
    
    @ViewBuilder
    private func showTutorialButton() -> some View {
        Button {
            sharedData.showTutorial1Sheet = true
        } label: {
            Image("arrow_right")
                .foregroundStyle(.primaryGray)
        }
    }
    
    private func hatchEggAPI(eggId: Int) {
        HomeService.shared.hatchEgg(eggId: eggId) { data in
            sharedData.currentHatchedEgg = data
            sharedData.isHatchable = true
            
            // 부화 로띠
            sharedData.hatchEggFlag = true
            Task {
                try? await Task.sleep(nanoseconds: 3 * 1_000_000_000)
                sharedData.hatchEggFlag = false
                
                // 캐릭터 팝업
                sharedData.showPopUp()
                homeVM.fetchHome()
                homeVM.fetchCurrentEgg()
            }
        }
    }
}

#Preview {
    HomeTab()
        .environmentObject(MyPageViewModel())
}
