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
                    VStack(alignment: .leading) {
                        Text("러닝")
                            .font(.caption_regular)
                            .foregroundStyle(.quaternaryGray)
                        Text("1")
                            .font(.title5_bold)
                            .foregroundStyle(.primaryGray)
                    }
                    VStack(alignment: .leading) {
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
}

#Preview {
    HomeTab()
}
