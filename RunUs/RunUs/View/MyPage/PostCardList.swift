//
//  PostCardList.swift
//  RunUs
//
//  Created by 가은 on 11/4/24.
//

import SwiftUI

struct PostCardList: View {
    @Environment(\.dismiss) var dismiss
    var postList: [RunningPost] = []
    private let nickname = UserDefaults.standard.string(forKey: "nickname") ?? ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Divider()
                header()
                    .padding(.horizontal, 16)
                    .padding(.vertical, 24)
                
                ScrollView {
                    ForEach(postList) { post in
                        PostCard(runningPost: post)
                            .padding(.bottom, 14)
                    }
                }
                .padding(.horizontal, 16)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 8) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 14, height: 14)
                        }
                        Text("모든 활동")
                            .font(.body1_medium)
                    }
                    .foregroundStyle(.gray900)
                }
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
            .foregroundStyle(.gray900)
            Text("\(nickname)님은 10월달에 총 22번을 달리셨어요.\n서울에서 부산까지의 거리를 달리셨네요! (250km)")
                .font(.body2_medium)
                .foregroundStyle(.gray500)
        }
    }
}

#Preview {
    PostCardList()
}
