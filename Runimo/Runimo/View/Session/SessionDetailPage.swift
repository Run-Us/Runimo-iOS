//
//  SessionDetailPage.swift
//  RunUs
//
//  Created by 가은 on 12/6/24.
//

import SwiftUI

struct SessionDetailPage: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.primaryBG.ignoresSafeArea()
                VStack(spacing: 0) {
                    Divider()
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            sessionCreator()
                            sessionTitle()
                            sessionDetailEtc(title: "날짜와 시간", contents: "10월 4일 금요일 오후 4시 30분")
                            sessionDetailEtc(title: "만날 장소", contents: "올림픽공원 평화의 문")
                            sessionDetailEtc(title: "페이스 구간", contents: "5’30” - 6’00”")
                            RunningMembersCard()
                        }
                        .padding(16)
                    }
                    CTAButton(text: "세션 참가하기", disabled: false) {
                        // TODO: Add action
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 8, height: 14)
                            .foregroundStyle(.primaryGray)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image("vertical_dots")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.primaryGray)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func sessionCreator() -> some View {
        HStack(spacing: 24) {
            var imageURL: String?   // (임시)
            if let profile = imageURL {
                AsyncImage(url: URL(string: profile))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .frame(width: 40, height: 40)
            } else {
                Image("default_user_profile")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            VStack(alignment: .leading) {
                Text("초대형성훈")
                    .font(.title5_medium)
                    .foregroundStyle(.primaryGray)
                Text("Lv 1 · 12 km")
                    .font(.caption_regular)
                    .foregroundStyle(.quaternaryGray)
            }
        }
    }
    
    @ViewBuilder
    private func sessionTitle() -> some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("같이 45분 뛰어봐요")
                    .font(.title4_semibold)
                    .foregroundStyle(.primaryGray)
                Text("45분 목표 설정됨")
                    .foregroundStyle(.primary300)
            }
            Text("에그드랍 석촌점에서 집결 후, 차량으로 반포공원이동 -> 반포공원-서울웨이브아트센터 9.5k 러닝 예정입니다! 페이스는 6-7 사이로 생각하고 있습니다 :)\n함께하실 3분만 모집해요 🤸‍🤸‍🤸‍")
                .foregroundStyle(.quaternaryGray)
        }
        .font(.body2_medium)
    }
    
    @ViewBuilder
    private func sessionDetailEtc(title: String, contents: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.body1_medium)
                .foregroundStyle(.primaryGray)
            Text(contents)
                .font(.body2_medium)
                .foregroundStyle(.quaternaryGray)
        }
    }
}

#Preview {
    SessionDetailPage()
}
