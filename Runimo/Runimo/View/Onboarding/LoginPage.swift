//
//  LoginPage.swift
//  RunUs
//
//  Created by 가은 on 9/4/24.
//

import AuthenticationServices
import SwiftUI

struct LoginPage: View {
    @EnvironmentObject var navigation: NavigationManager
    @EnvironmentObject var sharedData: SharedData
    @StateObject var authVM: AuthViewModel = AuthViewModel()
    let loginView: [String] = ["login_image1", "login_image2", "login_image3"]
    let loginViewTitle: [String] = ["달리기로 알을 부화시키세요!", "다양한 캐릭터를 수집하세요!", "더 많은 기능이 기다리고 있어요!"]
    @State var currentIndex: Int = 0
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Image("app_logo")
            TabView(selection: $currentIndex) {
                ForEach(Array(zip(loginView.indices, loginView)), id: \.0) { index, view in
                    loginCard(view: view,
                              title: loginViewTitle[index])
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 360)
            
            HStack {
                ForEach(loginView.indices, id: \.self) { index in
                    Capsule()
                        .foregroundColor(currentIndex == index ? .primary500 : .primary200)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.bottom)
            
            VStack {
                // kakao login
                Button(action: {
                    authVM.kakaoLogin { result in
                        handleNextPage(result)
                    }
                }, label: {
                    Image("kakao_login_button")
                })
                
                SignInWithAppleButton { request in
                    request.requestedScopes = []
                } onCompletion: { result in
                    switch result {
                    case .success(let authResults):
                        authVM.appleLogin(authResults) { result in
                            handleNextPage(result)
                        }
                    case .failure(let error):
                        print("Authorization failed: \(error.localizedDescription)")
                    }
                }
                .signInWithAppleButtonStyle(.black)
                .frame(height: 54)

                
            }
        }
        .padding(.horizontal, 20)
        .background(.secondaryBG)
    }
    
    @ViewBuilder
    func loginCard(view: String, title: String) -> some View {
        VStack {
            Image(view)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(title)
                .font(.title4_semibold)
                .foregroundColor(.primaryGray)
                .padding(.top, 8)
        }
        .padding()
    }
    
    private func handleNextPage(_ code: Int) {
        if code == 404 {
            // 회원가입
            navigation.path.append(JoinPage.id)
        } else if code == 200 {
            // 로그인
            sharedData.setTab(.home)
            sharedData.isLogined = true
        }
    }
}

#Preview {
    LoginPage()
}
