//
//  SettingPage.swift
//  Runimo
//
//  Created by 가은 on 4/12/25.
//

import SwiftUI

struct SettingPage: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.primaryBG
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 24) {
                Divider()
                // 로그아웃
                Button {
                    
                } label: {
                    HStack(spacing: 12) {
                        Image("icon_logout")
                        Text("로그아웃")
                            .font(.body2_medium)
                    }
                    .foregroundStyle(.secondaryGray)
                }
                
                // 탈퇴하기
                Button {
                    
                } label: {
                    HStack(spacing: 12) {
                        Image("trash")
                        Text("탈퇴하기")
                            .font(.body2_medium)
                    }
                    .foregroundStyle(.error)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 8, height: 14)
                        Text("내 활동")
                            .font(.body1_medium)
                    }
                    .foregroundStyle(.primaryGray)
                }
                .foregroundStyle(.primaryGray)
            }
        }
    }
}

#Preview {
    SettingPage()
}
