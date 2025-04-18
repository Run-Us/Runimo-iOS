//
//  RunUsApp.swift
//  RunUs
//
//  Created by 가은 on 8/31/24.
//

import KakaoSDKAuth
import KakaoSDKCommon
import SwiftUI

@main
struct RunimoApp: App {
    init() {
        // kakao sdk 초기화
        let kakaoNativeAppKey = (Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String) ?? ""
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
    }

    var body: some Scene {
        WindowGroup {
            LoginPage()
                .onOpenURL(perform: { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                })
                .environmentObject(MapViewModel())
                .environmentObject(RunningViewModel())
                .environmentObject(SharedData())
                .environmentObject(NavigationManager())
        }
    }
}
