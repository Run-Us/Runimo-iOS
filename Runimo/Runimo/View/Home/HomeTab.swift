//
//  HomePage.swift
//  RunUs
//
//  Created by byeoungjik on 9/9/24.
//

import SwiftUI

struct HomeTab: View {
    @EnvironmentObject var myPageVM: MyPageViewModel
    @EnvironmentObject var sharedData: SharedData
    @State private var data: HomeItem?
    @State private var eggData: HomeEggResponse?
    @State private var eggId: Int = 0
    @State private var addPoint: Int = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.primaryBG
            GeometryReader { _ in
                VStack(spacing: 24) {
                    Button {
                        myPageVM.currentMainTab = .character
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
            HomeService.shared.getHome { item in
                data = item
                sharedData.egg_love = (item.user_info.total_egg_count, item.user_info.love_point)
            }
            
            HomeService.shared.getCurrentEgg { egg in
                eggData = egg
                eggId = egg.incubating_eggs.first?.id ?? -1
            }
        }
    }

    @ViewBuilder
    private func characterProfile() -> some View {
        HStack(spacing: 46) {
            if let image = data?.main_runimo_stat_nullable?.image_url {
                AsyncImage(url: URL(string: image))
                    .frame(width: 86, height: 86)
            } else {
                Image("character_disabled")
                    .resizable()
                    .frame(width: 86, height: 86)
            }
                
            VStack(alignment: .leading, spacing: 20) {
                Text("\(data?.main_runimo_stat_nullable?.name ?? "알을 부화시켜보세요!")")
                    .foregroundStyle(.primaryGray)
                    .font(.title5_bold)
                HStack(spacing: 40) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("러닝")
                            .font(.caption_regular)
                            .foregroundStyle(.quaternaryGray)
                        Text("\(data?.main_runimo_stat_nullable?.total_running_count ?? 0)")
                            .font(.title5_bold)
                            .foregroundStyle(.primaryGray)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("달린 거리")
                            .font(.caption_regular)
                            .foregroundStyle(.quaternaryGray)
                        Text(String(format: "%.2f km", (data?.main_runimo_stat_nullable?.total_distance_in_meters ?? 0)/1000))
                            .font(.title5_bold)
                            .foregroundStyle(.primaryGray)
                    }
                    Spacer()
                }
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
    private func eggCard() -> some View {
        VStack(spacing: 12) {
            if let data = eggData, let egg = data.incubating_eggs.first {
                AsyncImage(url: URL(string: egg.img_url))
                
                HStack {
                    Text(egg.name)
                        .font(.title5_bold)
                        .foregroundStyle(.primaryGray)
                    Spacer()
                    Text("\(egg.current_love_point_amount+addPoint)/\(egg.hatch_required_point_amount)")
                        .font(.caption_regular)
                        .foregroundStyle(.quaternaryGray)
                }
                .padding(.bottom, 12)
                
                ProgressBar(progress: Double(egg.current_love_point_amount+addPoint)/Double(egg.hatch_required_point_amount))
                
                giveLoveButton()
            } else {
                Image("incubator_image")
                
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
    private func giveLoveButton() -> some View {
        Button {
            if eggId >= 0 && data?.user_info.love_point ?? 0 > 0 {
                addPoint += 1
                HomeService.shared.patchLovePoint(eggId: eggId, amount: 1) { response in
                    eggData?.incubating_eggs[0].current_love_point_amount = response.current_love_point_amount
                    sharedData.egg_love = (sharedData.egg_love.egg, sharedData.egg_love.love)
                    if response.egg_hatchable {
                        HomeService.shared.hatchEgg(eggId: response.egg_id) { data in
                            sharedData.characterPopUpData.character = data
                            sharedData.isHatchable = true
                            sharedData.showCharacterPopUp = true
                        }
                    }
                }
            }
            
        } label: {
            HStack(spacing: 8) {
                Image("icon_love")
                Text("애정 주기")
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
            sharedData.egg_love = (sharedData.egg_love.egg - 1, sharedData.egg_love.love)
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
}

#Preview {
    HomeTab()
        .environmentObject(MyPageViewModel())
}
