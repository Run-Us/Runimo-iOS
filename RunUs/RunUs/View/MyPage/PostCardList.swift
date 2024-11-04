//
//  PostCardList.swift
//  RunUs
//
//  Created by 가은 on 11/4/24.
//

import SwiftUI

struct PostCardList: View {
    var body: some View {
        VStack(alignment: .leading) {
            header()
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func header() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("2024년 10월")
                    .font(.title4_semibold)
                Button {
                    
                } label: {
                    Image("arrow_down")
                }
                Spacer()
            }
            .foregroundStyle(.gray900)
            Text("닉네임은최대여덟님은 10월달에 총 22번을 달리셨어요.\n서울에서 부산까지의 거리를 달리셨네요! (250km)")
                .font(.body2_medium)
                .foregroundStyle(.gray500)
        }
    }
}

#Preview {
    PostCardList()
}
