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
    @EnvironmentObject var myPageVM: MyPageViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color.primaryBG
                    .ignoresSafeArea()
                VStack {
                    // 상단 바
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Image("logo_black")
                                .resizable()
                                .frame(width: 104, height: 24)
                                .foregroundStyle(.primaryGray)
                        }
                        .padding(16)
                        Divider()
                    }
                    
                    // 커스텀 탭바
                    VStack {
                        Spacer()
                        
                        // 탭 별 보여줄 페이지
                        switch (myPageVM.currentMainTab) {
                        case .home: HomeTab()
                        case .session: EmptyView()
                        case .character: EmptyView()
                        case .my:   MyTab()
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
                                    myPageVM.currentMainTab = .home
                                } label: {
                                    Image("tab_home")
                                        .renderingMode(.template)
                                        .foregroundStyle(myPageVM.currentMainTab == .home ? .primaryGray : .gray400)
                                        .frame(width: 32, height: 32)
                                }
                                
                                Spacer()
                                Spacer()
                                
                                Button {
                                    myPageVM.currentMainTab = .session
                                } label: {
                                    Image("tab_globe")
                                        .renderingMode(.template)
                                        .foregroundStyle(myPageVM.currentMainTab == .session ? .primaryGray : .gray400)
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
                                    myPageVM.currentMainTab = .character
                                } label: {
                                    Image("tab_character")
                                        .renderingMode(.template)
                                        .foregroundStyle(myPageVM.currentMainTab == .character ? .primaryGray : .gray400)
                                        .frame(width: 32, height: 32)
                                }
                                
                                Spacer()
                                Spacer()
                                
                                // 마이페이지
                                Button {
                                    myPageVM.currentMainTab = .my
                                } label: {
                                    Image("tab_user")
                                        .renderingMode(.template)
                                        .foregroundStyle(myPageVM.currentMainTab == .my ? .primaryGray : .gray400)
                                        .frame(width: 32, height: 32)
                                }
                                
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    TabBar()
}
