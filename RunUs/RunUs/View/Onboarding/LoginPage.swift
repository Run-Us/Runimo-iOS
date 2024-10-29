//
//  LoginPage.swift
//  RunUs
//
//  Created by 가은 on 9/4/24.
//

import SwiftUI

struct LoginPage: View {
    @StateObject var authVM: AuthViewModel = AuthViewModel()
    @State private var loginSuccess: Bool = false
    @State private var showJoinPage: Bool = false
    let loginView: [String] = ["login_view_1", "login_view_2", "login_view_3"]
    let loginViewTitle: [String] = ["친구와 함께 달려보세요!", "러닝 크루와 함께 소통하세요!", "캐릭터와 함께 성장하세요!"]
    let loginViewContent: [String] = ["위치를 공유하며 그룹원과 함께 달리기를 즐겨보세요.", "크루의 세션 일정과 장소를 확인하고 기록을 공유하세요.", "달리기를 통해 나만의 캐릭터를 키우는 재미를 느껴보세요."]
    @State var currentIndex: Int = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.tone)
                VStack(alignment: .center, spacing: 24) {
                    Image("app_logo")
                    TabView(selection: $currentIndex) {
                        ForEach(Array(zip(loginView.indices, loginView)), id: \.0) { index, view in
                            loginCard(view: view,
                                      title: loginViewTitle[index],
                                      content: loginViewContent[index])
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
                            authVM.kakaoLogin { isSuccess in
                                showJoinPage = isSuccess
                            }
                        }, label: {
                            Image("kakao_login_button")
                            
                        })
                        .navigationDestination(isPresented: $showJoinPage) {
                            JoinPage(loginSuccess: $loginSuccess)
                                .navigationBarBackButtonHidden(true)
                        }
                        // apple login
                        Button(action: {
                            
                        }, label: {
                            Image("apple_login_button")
                        })
                    }
                }
                .padding(.horizontal, 20)
            }
            .ignoresSafeArea()
            .onAppear {
                if authVM.checkUserIdExists() {
                    loginSuccess = true
                }
            }
            .fullScreenCover(isPresented: $loginSuccess) {
                TabBar()
            }
        }
    }
    
    @ViewBuilder
        func loginCard(view: String, title: String, content: String) -> some View {
            VStack {
                Image(view)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text(title)
                    .font(.title4_semibold)
                    .foregroundColor(.gray900)
                    .padding(.top, 8)
                Text(content)
                    .font(.body2_medium)
                    .foregroundColor(.gray500)
            }
            .padding()
        }
}

#Preview {
    LoginPage()
}
