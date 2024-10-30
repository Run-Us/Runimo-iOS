//
//  MyPage.swift
//  RunUs
//
//  Created by byeoungjik on 9/9/24.
//

import SwiftUI

struct MyTab: View {
    @Environment(\.dismiss) var dismiss
    let userDefaults = UserDefaults.standard
    
    var body: some View {
        ScrollView {
            userInfo()
                .padding(.vertical, 24)
        }
        .padding(.horizontal, 16)
        VStack {
            Button(action: {
                UserDefaults.standard.removeObject(forKey: "idToken")
                UserDefaults.standard.removeObject(forKey: "userId")
                dismiss()
            }, label: {
                Text("로그아웃")
                    .foregroundColor(.white)
                    .padding()
            })
            .background(.blue)
            .cornerRadius(10)
        }
    }
    
    @ViewBuilder
    func userInfo() -> some View {
        HStack(spacing: 24) {
            // 프로필 사진
            Image("default_user_profile")
                .resizable()
                .frame(width: 80, height: 80)
            // 닉네임
            VStack(alignment: .leading, spacing: 10) {
                Text(userDefaults.string(forKey: "nickname") ?? "닉네임")
                    .font(.title4_semibold)
                    .foregroundStyle(.gray900)
                Text("누적 거리: 12km")
                Text("최근 러닝: 3일 전")
            }
            .font(.caption_regular)
            .foregroundStyle(.gray500)
            
            Spacer()
            
            Button {
                
            } label: {
                Image("edit_profile")
            }

        }
    }
}

#Preview {
    MyTab()
}
