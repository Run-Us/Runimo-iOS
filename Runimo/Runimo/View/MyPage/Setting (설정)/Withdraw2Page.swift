//
//  Withdraw2Page.swift (탈퇴 안내)
//  Runimo
//
//  Created by 가은 on 6/24/25.
//

import SwiftUI
import KeychainSwift

struct Withdraw2Page: View {
    @EnvironmentObject var navigation: NavigationManager
    @EnvironmentObject var sharedData: SharedData
    @State private var showWithdrawPopup: Bool = false
    let keychain = KeychainSwift()
    
    var body: some View {
        ZStack {
            Color.primaryBG.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 24) {
                Divider()
                Text("\(UserDefaults.standard.string(forKey: "nickname") ?? "")님,\n탈퇴하기 전에 확인해주세요")
                    .font(.title4_semibold)
                    .foregroundStyle(.primaryGray)
                    .padding(.horizontal, 16)
                Text("""
                     • 러니모에서 저장한 활동 기록을 다시 볼 수 없어요.

                     • 누적된 러닝 거리는 복구가 불가능해요.

                     • 보유한 캐릭터와 애정도도 함께 사라지며, 복구할 수 없어요
                    """)
                .font(.body2_medium)
                .foregroundStyle(.secondaryGray)
                .padding(.horizontal, 16)
                
                Spacer()
                
                CTAButton(text: "탈퇴하기", isError: true, disabled: false) {
                    showWithdrawPopup = true
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    navigation.path.removeLast()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 8, height: 14)
                        .padding(.horizontal, 5)
                        .foregroundStyle(.primaryGray)
                }
            }
        }
        .popup(isPresented: $showWithdrawPopup, title: "계정을 삭제할까요?", subtitle: "모든 데이터는 복구되지 않아요.", buttonText: "탈퇴하기", buttonColor: .error) {

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
    Withdraw2Page()
}
