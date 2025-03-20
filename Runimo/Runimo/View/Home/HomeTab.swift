//
//  HomePage.swift
//  RunUs
//
//  Created by byeoungjik on 9/9/24.
//

import SwiftUI

struct HomeTab: View {
    var body: some View {
        ZStack(alignment: .top) {
            Color.primaryBG
            VStack(spacing: 24) {
                characterProfile()
                eggCard()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
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
                        Text("1")
                            .font(.title5_bold)
                            .foregroundStyle(.primaryGray)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("달린 거리")
                            .font(.caption_regular)
                            .foregroundStyle(.quaternaryGray)
                        Text("3.43 km")
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
                Text("0/10")
                    .font(.caption_regular)
                    .foregroundStyle(.quaternaryGray)
            }
            .padding(.bottom, 12)
            ProgressBar(progress: .constant(0.0))
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
}
