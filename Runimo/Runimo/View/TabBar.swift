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
    @State private var showSignUpCompletePopUp: Bool = false

    var body: some View {
        ZStack {
            Color.primaryBG.ignoresSafeArea()
            VStack(spacing: 0) {
                // 상단 바
                switch sharedData.currentMainTab {
                case .session: runningRecordsNavigationBar()
                case .character: characterTabNavigationBar()
                default: etcNavigationBar()
                }
                
                // 탭 별 보여줄 페이지
                switch sharedData.currentMainTab {
                case .home: HomeTab()
                case .session: PostCardList()
                case .character: CharacterTab()
                case .my: MyTab()
                }
                
                // 탭 아이콘
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
                    Button {
                        navigation.path.append(RunTab.id)
                    } label: {
                        Image("tab_play")
                            .offset(y: -15)
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
                .background(Divider(), alignment: .top)
            }
            
            if sharedData.hatchEggFlag {
                hatchEggPopup()
            }
            
            if showSignUpCompletePopUp {
                signUpPopUp()
            }
        }
        .navigationBarBackButtonHidden()
        .popupCharacter(isPresented: $sharedData.showCharacterPopUp, character: sharedData.characterPopUpData, isHatching: sharedData.isHatchable)
        .onAppear {
            
            RunimoService.shared.getAllRunimos { data in
                sharedData.allRunimoData = data.runimo_groups
                sharedData.transformAllRunimo()
            }
            
            // 회원가입 후 팝업 띄우기 위함
            Task {
                try? await Task.sleep(for: .seconds(0.3))
                showSignUpCompletePopUp = sharedData.isSignUpComplete
            }
        }
        .onChange(of: sharedData.currentMainTab) { _, _ in
            sharedData.dateSheetSelectedIndex = 0
        }
        .sheet(isPresented: $sharedData.showEggSheet, content: {
            EggSheet()
                .presentationDetents([.fraction(0.25)])
        })
        .sheet(isPresented: $sharedData.showTutorial1Sheet) {
            Tutorial1Sheet()
                .presentationDetents([.fraction(0.48)])
        }
        .sheet(isPresented: $sharedData.showTutorial2Sheet) {
            Tutorial2Sheet()
                .presentationDetents([.fraction(0.5)])
        }
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
    private func runningRecordsNavigationBar() -> some View {
        VStack(spacing: 0) {
            HStack {
                Text("모든 활동")
                    .font(.title5_bold)
                    .frame(height: 24)
                Spacer()
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
                Text(CommonExtension.formatIntToKM(num: sharedData.totalUserRunningDistance))
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
                        Text(CommonExtension.formatNumber(num: sharedData.egg_love.egg))
                        Image("icon_love")
                            .padding(.leading, 8)
                        Text(CommonExtension.formatNumber(num: sharedData.egg_love.love))
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
    
    // 회원가입 후 알 지급 팝업
    @ViewBuilder
    private func signUpPopUp() -> some View {
        ZStack {
            Color.quaternaryGray.opacity(0.3).ignoresSafeArea()
            VStack(spacing: 8) {
                Text("신비로운 알을 발견했어요")
                    .font(.title4_semibold)
                    .foregroundStyle(.primaryGray)
                Text("회원가입을 기념해 애정 10개를 드릴게요.\n지금 알을 등록하고 부화시켜 보세요!")
                    .font(.body2_medium)
                    .foregroundStyle(.tertiaryGray)
                    .multilineTextAlignment(.center)
                LottieView(source: .asset(name: "\(sharedData.firstEgg.code)-02-갸우뚱", mode: .loop), reloadID: UUID())
                    .frame(height: 330)
                
                Button {
                    sharedData.isSignUpComplete = false
                    showSignUpCompletePopUp = false
                    
                    HomeService.shared.postEgg(egg_id: sharedData.firstEgg.id) {
                        sharedData.updateHomeView.toggle()
                    }
                } label: {
                    Text("알 등록하기")
                        .font(.body1_bold)
                        .foregroundStyle(.white)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(.primary400)
                        .cornerRadius(8)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12).fill(.primaryBG)
            )
            .padding(16)
        }
    }
    
    @ViewBuilder
    private func hatchEggPopup() -> some View {
        ZStack {
            Color.quaternaryGray.opacity(0.3).ignoresSafeArea()
            VStack(spacing: 16) {
                Text("부화!!!")
                    .font(.title4_semibold)
                    .foregroundStyle(.primaryGray)
                LottieView(source: .asset(name: "\(sharedData.eggCode)-01-알부화", mode: .playOnce), reloadID: UUID())
                    .frame(height: 330)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12).fill(.primaryBG)
            )
            .padding(16)
        }
    }
}

#Preview {
    TabBar()
}
