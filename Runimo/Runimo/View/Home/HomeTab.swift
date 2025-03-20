//
//  HomePage.swift
//  RunUs
//
//  Created by byeoungjik on 9/9/24.
//

import SwiftUI

struct HomeTab: View {
    @EnvironmentObject var myPageVM: MyPageViewModel
    @State private var sessionCardIndex: Int = 0
    @State private var showFindCrewPage: Bool = false
    @State private var showCrewHomePage: Bool = false
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            ZStack {
                Color.primaryBG
                VStack(spacing: 24) {
                    userProfile()
                    RecordCard()
                    runningSession()
                    myCrewList()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 24)
            }
        }
        .navigationDestination(isPresented: $showCrewHomePage) {
            // dummy TODO: API 연결
            CrewHomePage(crew: Crew(crew_public_id: "", title: "Run with Us", profile_image: "", location: "서울 광진구", intro: "런어스 공식크루", join_type: "자유", crew_type: "동네친구", member_count: 5, created_at: "", exist_new_join_request: false, this_month_record: CrewMonthRecord(running_count: 2, total_distance: 2000, total_time: 500), regular_running: nil, irregular_running: nil))
        }
    }
    
    @ViewBuilder
    private func userProfile() -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 7) {
                Text("\(UserDefaults.standard.string(forKey: "nickname") ?? "")님")
                    .foregroundStyle(.primaryGray)
                    .font(.title5_bold)
                Text("Lv1 ∙ 12km")
                    .foregroundStyle(.quaternaryGray)
                    .font(.caption_semibold)
                ProgressBar(progress: .constant(0.7))
            }
            Image("default_user_profile")
                .resizable()
                .frame(width: 60, height: 60)
        }
    }
    
    @ViewBuilder
    private func runningSession() -> some View {
        // 러닝 세션 없을 때
        if true {
            Button {
                myPageVM.currentMainTab = .session
            } label: {
                HStack(spacing: 8) {
                    Image("globe_box")
                    Text("러닝세션 찾아보기")
                        .font(.title5_bold)
                        .foregroundStyle(.primaryGray)
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.secondaryFill, lineWidth: 1)
                )
            }
        }
        // 러닝 세션 있을 떄
        else {
            scheduledRunning()
        }
    }
    
    @ViewBuilder
    private func scheduledRunning() -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("예정 러닝세션")
                    .font(.title5_bold)
                    .foregroundStyle(.primaryGray)
                Spacer()
                Button {
                    
                } label: {
                    Text("더 보기")
                        .font(.caption_regular)
                        .foregroundStyle(.quaternaryGray)
                }
            }
            
            TabView(selection: $sessionCardIndex) {
                // TODO: 세션카드 (JIS-48)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // page dots
            HStack {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundStyle(index == sessionCardIndex ? .primary500 : .primary200)
                }
            }
        }
    }
    
    @ViewBuilder
    private func myCrewList() -> some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("내 크루")
                .font(.title5_bold)
                .foregroundStyle(.primaryGray)
            LazyVGrid(columns: columns, spacing: 30) {
                // TODO: 리스트로 변경
                crew(imageURL: nil, crewName: "런런런")
                crew(imageURL: nil, crewName: "런어스")
                crew(imageURL: nil, crewName: "러닝크루")
                crew(imageURL: nil, crewName: "런잉클우")
                crew(imageURL: nil, crewName: "Run with US 공식크루")
                
                // find crew button
                Button {
                    showFindCrewPage = true
                } label: {
                    VStack(spacing: 8) {
                        Image("search_crew")
                            .resizable()
                            .frame(width: 60, height: 60)
                        
                        Text("크루 찾기")
                            .font(.caption_regular)
                            .foregroundStyle(.quaternaryGray)
                            .lineLimit(2)
                            .frame(width: 60, height: 25, alignment: .top)
                            .truncationMode(.tail)
                    }
                }
                .navigationDestination(isPresented: $showFindCrewPage) {
                    FindCrewPage()
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.primaryFill)
                .stroke(.secondaryFill, lineWidth: 1)
        )
    }
    
    @ViewBuilder
    private func crew(imageURL: String?, crewName: String) -> some View {
        Button {
            showCrewHomePage = true
        } label: {
            VStack(spacing: 8) {
                if let profile = imageURL {
                    AsyncImage(url: URL(string: profile))
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                } else {
                    Image("crew_default_profile")
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                
                Text(crewName)
                    .font(.caption_regular)
                    .foregroundStyle(.quaternaryGray)
                    .lineLimit(2)
                    .frame(width: 60, height: 25, alignment: .top)
                    .truncationMode(.tail)
            }
        }
    }
}

#Preview {
    HomeTab()
        .environmentObject(MyPageViewModel())
}
