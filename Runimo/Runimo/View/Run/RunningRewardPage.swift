//
//  RunningRewardPage.swift
//  Runimo
//
//  Created by 가은 on 5/1/25.
//

import SwiftUI

struct RunningRewardPage: View {
    @EnvironmentObject var navigation: NavigationManager
    @EnvironmentObject var sharedData: SharedData
    
    var body: some View {
        ZStack {
            Color.primaryBG.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 48) {
                Spacer()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("오늘의 러닝을 성공적으로 마쳤어요!")
                        .font(.title4_semibold)
                        .foregroundStyle(.primaryGray)
                    Text("nn분 동안 n.nnkm를 달렸어요. 정말 대단해요!")
                        .font(.body2_medium)
                        .foregroundStyle(.quaternaryGray)
                }
                .padding(.horizontal, 16)
                
                VStack(spacing: 12) {
                    if !sharedData.rewardData.egg.isEmpty {
                        rewardItem(image: "icon_egg", text: sharedData.rewardData.egg)
                    }
                    rewardItem(image: "icon_love", text: "\(sharedData.rewardData.point)개")
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
                CTAButton(text: "다음", disabled: false) {
                    navigation.path.append(FinishRunningPage.id)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    @ViewBuilder
    private func rewardItem(image: String, text: String) -> some View {
        HStack(spacing: 8) {
            Spacer()
            Image(image)
            Text(text)
                .font(.title5_bold)
                .foregroundStyle(.primaryGray)
                .padding(.vertical, 16)
            Spacer()
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.secondaryFill)
        )
    }
}

#Preview {
    RunningRewardPage()
}
