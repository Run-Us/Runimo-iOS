//
//  PostCard.swift
//  RunUs
//
//  Created by 가은 on 11/1/24.
//

import SwiftUI

struct PostCard: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 러닝 정보
            runningInfo()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.tone)
                .stroke(.gray200, lineWidth: 1)
        )
    }
    
    @ViewBuilder
    func runningInfo() -> some View {
        HStack {
            // 러닝 정보
            VStack(alignment: .leading, spacing: 12) {
                Text("9월 30일 월요일")
                    .font(.body2_semibold)
                    .foregroundStyle(.gray500)
                Text("10k 러닝")
                    .font(.title5_bold)
                HStack(spacing: 20) {
                    detailInfo(title: "거리", contents: "12.42km")
                    detailInfo(title: "페이스", contents: "5'55")
                    detailInfo(title: "시간", contents: "1h 5m")
                }
            }
            .foregroundStyle(.gray900)
            
            Spacer()
            
            // 경로 이미지
        }
    }
    
    @ViewBuilder
    func detailInfo(title: String, contents: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption_regular)
                .foregroundStyle(.gray500)
            Text(contents)
                .font(.caption_bold)
                .foregroundStyle(.gray900)
        }
    }
}

#Preview {
    PostCard()
}
