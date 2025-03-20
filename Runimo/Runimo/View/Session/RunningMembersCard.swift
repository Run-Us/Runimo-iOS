//
//  RunningMembersCard.swift
//  RunUs
//
//  Created by 가은 on 12/21/24.
//

import SwiftUI

struct RunningMembersCard: View {
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            headerView(nickname: "주최자닉네임")
            memberList()
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
    private func headerView(nickname: String) -> some View {
        HStack {
            Text("참가 중인 러너")
                .font(.title5_bold)
                .foregroundStyle(.primaryGray)
            Spacer()
            Text("주최자: \(nickname)")
                .font(.caption_regular)
                .foregroundStyle(.quaternaryGray)
        }
    }
    
    @ViewBuilder
    private func memberList() -> some View {
        LazyVGrid(columns: columns, spacing: 12) {
            // TODO: 리스트로 변경
            member(imageURL: nil, nickname: "닉네임 1")
            member(imageURL: nil, nickname: "닉네임 2")
            member(imageURL: nil, nickname: "닉네임3닉네임3닉네")
            member(imageURL: nil, nickname: "닉네임 4")
            member(imageURL: nil, nickname: "닉네임 5")
        }
    }
    
    @ViewBuilder
    private func member(imageURL: String?, nickname: String) -> some View {
        VStack(spacing: 8) {
            if let profile = imageURL {
                AsyncImage(url: URL(string: profile))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .frame(width: 60, height: 60)
            } else {
                Image("default_user_profile")
                    .resizable()
                    .frame(width: 60, height: 60)
            }
            Text(nickname)
                .font(.caption_regular)
                .foregroundStyle(.quaternaryGray)
                .lineLimit(2)
                .frame(width: 60, height: 28, alignment: .top)
        }
    }
}

#Preview {
    RunningMembersCard()
}
