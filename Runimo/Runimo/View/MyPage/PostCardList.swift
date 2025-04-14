//
//  PostCardList.swift
//  RunUs
//
//  Created by 가은 on 11/4/24.
//

import SwiftUI

struct PostCardList: View {
    @EnvironmentObject var navigation: NavigationManager
    var runningSessionList: [RunningRecord] = []
    private let nickname = UserDefaults.standard.string(forKey: "nickname") ?? ""
    
    var body: some View {
        ZStack {
            Color.primaryBG
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Divider()
                header()
                    .padding(.horizontal, 16)
                    .padding(.vertical, 24)
                
                ScrollView {
                    ForEach(runningSessionList, id: \.title) { record in
                        PostCard(runningRecord: record)
                            .padding(.bottom, 14)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: 8) {
                    Button {
                        navigation.path.removeLast()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 14, height: 14)
                    }
                    Text("모든 활동")
                        .font(.body1_medium)
                }
                .foregroundStyle(.primaryGray)
            }
        }
        .navigationBarBackButtonHidden()
    }

    @ViewBuilder
    private func header() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("2024년 10월")
                    .font(.title4_semibold)
                Button {} label: {
                    Image("arrow_down")
                }
                Spacer()
            }
            .foregroundStyle(.primaryGray)
            Text("\(nickname)님은 10월달에 총 22번을 달리셨어요.\n서울에서 부산까지의 거리를 달리셨네요! (250km)")
                .font(.body2_medium)
                .foregroundStyle(.quaternaryGray)
        }
    }
}

#Preview {
    PostCardList()
}
