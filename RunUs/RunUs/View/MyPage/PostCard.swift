//
//  PostCard.swift
//  RunUs
//
//  Created by 가은 on 11/1/24.
//

import SwiftUI

struct PostCard: View {
    var runningPost: RunningPost
    
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
                Text(runningPost.createdAt)
                    .font(.body2_semibold)
                    .foregroundStyle(.quaternaryGray)
                Text(runningPost.title)
                    .font(.title5_bold)
                HStack(spacing: 20) {
                    detailInfo(title: "거리", contents: String(format: "%.2f", runningPost.runningInfo.distance ?? 0))
                    detailInfo(title: "페이스", contents: runningPost.runningInfo.averagePace ?? "")
                    detailInfo(title: "시간", contents: runningPost.runningInfo.runningTime ?? "")
                }
            }
            .foregroundStyle(.primaryGray)
            
            Spacer()
            
            // 경로 이미지
        }
    }
    
    @ViewBuilder
    func detailInfo(title: String, contents: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption_regular)
                .foregroundStyle(.quaternaryGray)
            Text(contents)
                .font(.caption_bold)
                .foregroundStyle(.primaryGray)
        }
    }
}

#Preview {
    PostCard(runningPost: RunningPost(createdAt: "9월 20일 월요일", title: "10K 러닝", contents: "", runningInfo: RunningInfo()))
}
