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
    @State private var point: Int = 0
    
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
                sharedData.egg_love = (item.total_egg_count, item.love_point)
            }
        }
    }

    @ViewBuilder
    private func characterProfile() -> some View {
        HStack(spacing: 46) {
            Image("character_dog")
            VStack(alignment: .leading, spacing: 20) {
                Text("강아지")
                    .foregroundStyle(.primaryGray)
                    .font(.title5_bold)
                HStack(spacing: 40) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("러닝")
                            .font(.caption_regular)
                            .foregroundStyle(.quaternaryGray)
                        Text("\(data?.total_running_count ?? 0)")
                            .font(.title5_bold)
                            .foregroundStyle(.primaryGray)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("달린 거리")
                            .font(.caption_regular)
                            .foregroundStyle(.quaternaryGray)
                        Text(String(format: "%.2f km", (data?.total_distance_in_meters ?? 0)/1000))
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
            Image("home_egg_image")
            HStack {
                Text("마당 알")
                    .font(.title5_bold)
                    .foregroundStyle(.primaryGray)
                Spacer()
                Text("\(point)/10")
                    .font(.caption_regular)
                    .foregroundStyle(.quaternaryGray)
            }
            .padding(.bottom, 12)
            ProgressBar(progress: Double(point)/10)
            giveLoveButton()
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
            point = min(point+1, 10)
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
}

#Preview {
    HomeTab()
        .environmentObject(MyPageViewModel())
}
