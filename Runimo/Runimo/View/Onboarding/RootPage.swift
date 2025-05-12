//
//  RootPage.swift
//  Runimo
//
//  Created by 가은 on 5/2/25.
//

import SwiftUI

struct RootPage: View {
    @EnvironmentObject var navigation: NavigationManager
    @EnvironmentObject var sharedData: SharedData
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            ZStack {
                if let isLogined = sharedData.isLogined {
                    if isLogined {
                        TabBar()
                    } else {
                        LoginPage()
                    }
                }
            }
            .navigationDestination(for: String.self) { value in
                switch value {
                case LoginPage.id:
                    LoginPage().navigationBarBackButtonHidden()
                case TabBar.id:
                    TabBar().navigationBarBackButtonHidden()
                case JoinPage.id:
                    JoinPage().navigationBarBackButtonHidden()
                case PostCardList.id:
                    PostCardList()
                case SettingPage.id:
                    SettingPage()
                case RunTab.id:
                    RunTab()
                case RunningRewardPage.id:
                    RunningRewardPage()
                case FinishRunningPage.id:
                    FinishRunningPage()
                default:
                    Text("❓ Unknown destination: \(value)")
                }
            }
        }
        .onAppear {
            NetworkManager.shared.refreshToken { success in
                sharedData.isLogined = success
                if success {
                    sharedData.setTab(.home)
                }
            }
        }
    }
}

#Preview {
    RootPage()
}
