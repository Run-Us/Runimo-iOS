//
//  SettingPage.swift
//  Runimo
//
//  Created by 가은 on 4/12/25.
//

import SwiftUI
import KeychainSwift

struct SettingPage: View {
    @EnvironmentObject var navigation: NavigationManager
    @EnvironmentObject var sharedData: SharedData
    @State private var showLogoutPopup: Bool = false
    @State private var showWithdrawPopup: Bool = false
    let keychain = KeychainSwift()
    
    var body: some View {
        ZStack {
            Color.primaryBG
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 24) {
                Divider()
                // 로그아웃
                Button {
                    showLogoutPopup = true
                } label: {
                    HStack(spacing: 12) {
                        Image("icon_logout")
                        Text("로그아웃")
                            .font(.body2_medium)
                    }
                    .foregroundStyle(.secondaryGray)
                }
                .padding(.horizontal, 16)
                
                // 탈퇴하기
                Button {
                    showWithdrawPopup = true
                } label: {
                    HStack(spacing: 12) {
                        Image("trash")
                        Text("탈퇴하기")
                            .font(.body2_medium)
                    }
                    .foregroundStyle(.error)
                }
                .padding(.horizontal, 16)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    navigation.path.removeLast()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 8, height: 14)
                            .padding(.horizontal, 5)
                        Text("설정")
                            .font(.body1_medium)
                    }
                    .foregroundStyle(.primaryGray)
                }
            }
        }
        .popup(isPresented: $showLogoutPopup, title: "로그아웃 하시겠어요?", subtitle: "로그아웃해도 러닝 활동은 삭제되지 않아요.", buttonText: "로그아웃 하기", buttonColor: .primary400) {

        } buttonAction: {
            AuthService.shared.removeUserInfoToLogout()
            deleteToken()
            sharedData.isLogined = false
            navigation.goToRootPage()
        }
        .popup(isPresented: $showWithdrawPopup, title: "정말 탈퇴 하시겠어요?", subtitle: "저장된 활동 기록은 복구가 불가능해요.", buttonText: "탈퇴하기", buttonColor: .error) {

        } buttonAction: {
            MyPageService.shared.withdrawUser { result in
                if result {
                    deleteToken()
                    sharedData.isLogined = false
                    navigation.goToRootPage()
                }
            }
        }
    }
    
    private func deleteToken() {
        keychain.delete("accessToken")
        keychain.delete("refreshToken")
    }
}

#Preview {
    SettingPage()
}
