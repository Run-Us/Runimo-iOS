//
//  RunningPostPage.swift
//  RunUs
//
//  Created by 가은 on 10/22/24.
//

import SwiftUI

struct RunningPostPage: View {
    @StateObject var mapVM: MapViewModel
    let runningPost: RunningPost
    @State private var backToTabBar: Bool = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                Divider()
                
                VStack(alignment: .leading, spacing: 24) {
                    // 유저 정보
                    HStack(spacing: 24) {
                        // 프로필 사진
                        Image("default_user_profile")
                            .resizable()
                            .frame(width: 40, height: 40)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("닉네임")
                                .font(.title5_medium)
                            Text("2024년 9월 25일 (목) 오후 4:24")
                                .font(.caption_regular)
                                .foregroundStyle(.gray500)
                        }
                    }
                    
                    // title
                    Text(runningPost.title)
                        .font(.title4_semibold)
                    
                    // 완료한 러닝 정보
                    HStack(spacing: 32) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("거리")
                                .font(.caption_regular)
                                .foregroundStyle(.gray500)
                            Text(String(format: "%.2fkm", runningPost.runningInfo.distance ?? 0.0))
                                .font(.title5_bold)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("페이스")
                                .font(.caption_regular)
                                .foregroundStyle(.gray500)
                            Text(runningPost.runningInfo.averagePace ?? "-’--”")
                                .font(.title5_bold)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("시간")
                                .font(.caption_regular)
                                .foregroundStyle(.gray500)
                            Text(runningPost.runningInfo.runningTime ?? "0h 0m")
                                .font(.title5_bold)
                        }
                    }
                    
                    // contents
                    Text(runningPost.contents)
                        .font(.body2_medium)
                    
                    // 지도 이미지
                    
                    // 구간별 페이스
                    
                }
                .foregroundStyle(.gray900)
                .padding(.horizontal, 16)
                .padding(.vertical, 25)
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 6) {
                        Button {
                            backToTabBar = true
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 14, height: 14)
                        }
                        Text("내 활동")
                            .font(.body1_medium)
                    }
                    .foregroundStyle(.gray900)
                }
            }
            .navigationDestination(isPresented: $backToTabBar) {
                TabBar()
            }
        }
    }
}

#Preview {
    RunningPostPage(mapVM: .init(), runningPost: RunningPost(title: "모닝런", contents: "휴우우우우우", runningInfo: RunningInfo()))
}
