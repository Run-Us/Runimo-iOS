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
            // 유저 정보
            userInfo()
            // 러닝 정보
            runningInfo()
            // 러닝 설명
            runningExplanation(contents: "runningingingingin")
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
    func userInfo() -> some View {
        HStack(spacing: 24) {
            Image("default_user_profile")
                .resizable()
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("닉네임")
                    .font(.title5_medium)
                    .foregroundStyle(.gray900)
                Text("9월 30일 월요일 오전 2:36")
                    .font(.caption_regular)
                    .foregroundStyle(.gray500)
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    func runningInfo() -> some View {
        HStack {
            // 러닝 정보
            VStack(alignment: .leading, spacing: 12) {
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
    
    @ViewBuilder
    func runningExplanation(contents: String) -> some View {
        if !contents.isEmpty {
            Text(contents)
                .font(.caption_regular)
                .foregroundStyle(.gray500)
        }
    }
}

#Preview {
    PostCard()
}
