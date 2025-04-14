//
//  MainPage.swift
//  RunUs
//
//  Created by byeoungjik on 9/10/24.
//

import SwiftUI

enum Tab {
    case home
    case session
    case character
    case my
}

struct TabBar: View {
    @EnvironmentObject var navigation: NavigationManager
    @EnvironmentObject var sharedData: SharedData

    var body: some View {
        ZStack {
            Color.primaryBG
                .ignoresSafeArea()
            VStack {
                // 상단 바
                VStack(alignment: .leading, spacing: 0) {
                    switch sharedData.currentMainTab {
                    case .session: sessionTabNavigationBar()
                    case .character: characterTabNavigationBar()
                    default: etcNavigationBar()
                    }
                }
                
                // 커스텀 탭바
                VStack {
                    // 탭 별 보여줄 페이지
                    switch sharedData.currentMainTab {
                    case .home: HomeTab()
                    case .session: SessionTab()
                    case .character: CharacterTab()
                    case .my: MyTab()
                    }
                    
                    Spacer()
                        
                    // 탭 아이콘
                    VStack {
                        Divider()
                            .offset(y: 10)
                        HStack {
                            Spacer()
                                
                            // 홈
                            Button {
                                sharedData.currentMainTab = .home
                            } label: {
                                Image("tab_home")
                                    .renderingMode(.template)
                                    .foregroundStyle(sharedData.currentMainTab == .home ? .primaryGray : .gray400)
                                    .frame(width: 32, height: 32)
                            }
                                    
                            Spacer()
                            Spacer()
                                    
                            Button {
                                sharedData.currentMainTab = .session
                            } label: {
                                Image("tab_globe")
                                    .renderingMode(.template)
                                    .foregroundStyle(sharedData.currentMainTab == .session ? .primaryGray : .gray400)
                                    .frame(width: 32, height: 32)
                            }
                                    
                            Spacer()
                                    
                            // 달리기
                            NavigationLink(destination: RunTab()) {
                                Image("tab_play")
                                    .offset(y: -10)
                                    .frame(width: 60, height: 60)
                            }
                                    
                            Spacer()
                                    
                            Button {
                                sharedData.currentMainTab = .character
                            } label: {
                                Image("tab_character")
                                    .renderingMode(.template)
                                    .foregroundStyle(sharedData.currentMainTab == .character ? .primaryGray : .gray400)
                                    .frame(width: 32, height: 32)
                            }
                                    
                            Spacer()
                            Spacer()
                                    
                            // 마이페이지
                            Button {
                                sharedData.currentMainTab = .my
                            } label: {
                                Image("tab_user")
                                    .renderingMode(.template)
                                    .foregroundStyle(sharedData.currentMainTab == .my ? .primaryGray : .gray400)
                                    .frame(width: 32, height: 32)
                            }
                                    
                            Spacer()
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .popupCharacter(isPresented: $sharedData.showCharacterPopUp, isHatching: sharedData.isHatchable)
        .onReceive(NotificationCenter.default.publisher(for: .completeSignUp)) { _ in
            sharedData.showCharacterPopUp = true
        }
        .onAppear {
            HomeService.shared.getMyEggs { data in
                sharedData.myEggs = data.items
            }
            
            RunimoService.shared.getAllRunimos { data in
                sharedData.allRunimoData = data.runimo_groups
            }
        }
        .sheet(isPresented: $sharedData.showEggSheet, content: {
            EggSheet()
                .presentationDetents([.fraction(0.25)])
        })
    }
    
    @ViewBuilder
    private func settingButton() -> some View {
        Button {
            navigation.path.append(SettingPage.id)
        } label: {
            Image("icon_setting")
                .foregroundStyle(.primaryGray)
        }
    }
    
    @ViewBuilder
    private func sessionTabNavigationBar() -> some View {
        VStack(spacing: 0) {
            HStack {
                Text("러닝세션 찾기")
                    .font(.title5_bold)
                Spacer()
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 14, height: 14)
            }
            .foregroundStyle(.primaryGray)
            .padding(16)
            Divider()
        }
    }
    
    @ViewBuilder
    private func characterTabNavigationBar() -> some View {
        VStack(spacing: 0) {
            HStack {
                Text("캐릭터")
                    .font(.title5_bold)
                    .frame(height: 24)
                Spacer()
                Text("0km")
                    .font(.body1_medium)
            }
            .foregroundStyle(.primaryGray)
            .padding(16)
            Divider()
        }
    }
    
    @ViewBuilder
    func etcNavigationBar() -> some View {
        VStack(spacing: 0) {
            HStack {
                Image("logo_black")
                    .foregroundStyle(.primaryGray)
                Spacer()
                
                if sharedData.currentMainTab == .home {
                    HStack(spacing: 4) {
                        Image("icon_egg")
                        Text("\(sharedData.egg_love.egg)")
                        Image("icon_love")
                            .padding(.leading, 8)
                        Text("\(sharedData.egg_love.love)")
                    }
                    .font(.title5_bold)
                    .foregroundStyle(.primaryGray)
                } else {
                    settingButton()
                }
            }
            .padding(16)
            Divider()
        }
    }
}

#Preview {
    TabBar()
}
