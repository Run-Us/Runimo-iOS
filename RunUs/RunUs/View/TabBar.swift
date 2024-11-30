//
//  MainPage.swift
//  RunUs
//
//  Created by byeoungjik on 9/10/24.
//

import SwiftUI

enum Tab {
    case home
    case my
}

struct TabBar: View {
    @State private var selectedTab: Tab = .home

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
                        switch (selectedTab) {
                        case .home: HomeTab()
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
                                    selectedTab = .home
                                } label: {
                                    Image("tab_home")
                                        .renderingMode(.template)
                                        .foregroundStyle(selectedTab == .home ? .primaryGray : .gray400)
                                }
                                
                                Spacer()
                                
                                // 달리기
                                NavigationLink(destination: RunTab()) {
                                    Image("tab_play")
                                        .offset(y: -10)
                                }
                                
                                Spacer()
                                
                                // 마이페이지
                                Button {
                                    selectedTab = .my
                                } label: {
                                    Image("tab_user")
                                        .renderingMode(.template)
                                        .foregroundStyle(selectedTab == .my ? .primaryGray : .gray400)
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
