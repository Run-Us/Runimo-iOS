//
//  MyPage.swift
//  RunUs
//
//  Created by byeoungjik on 9/9/24.
//

import SwiftUI

struct MyTab: View {
    @EnvironmentObject var navigation: NavigationManager
    @StateObject private var myPageVM = MyPageViewModel()
    let userDefaults = UserDefaults.standard
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                userInfo()
                    .padding(.vertical, 24)
                    .padding(.horizontal, 16)
                
                SegmentedPicker(selectedTab: $myPageVM.selectedTab, type: ["주간","월간"], width: geometry.size.width)
                
                VStack(spacing: 24) {
                    RecordCard(myPageVM: myPageVM)
                    MyGraph(myPageVM: myPageVM)
                        .frame(height: 160)
                    recentActivity()
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 16)
            }
            
        }
        .sheet(isPresented: $myPageVM.showDateSheet) {
            DateSheet(recordType: myPageVM.recordType)
                .presentationDragIndicator(.visible)
                .presentationDetents([.fraction(0.35), .large])
        }
        .onAppear {
            DateManager.shared.setDateToday()
            MyPageService.shared.getMyPage { data in
                myPageVM.user = data
            }
        }
        .onChange(of: DateManager.shared.date) { oldValue, newValue in
            myPageVM.getGraphAPI()
        }
    }
    
    @ViewBuilder
    func userInfo() -> some View {
        HStack(spacing: 24) {
            // 프로필 사진
            if let profile = myPageVM.user.profile_image_url, profile != "" {
                AsyncImage(url: URL(string: profile))
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 32))
            } else {
                Image("default_user_profile")
                    .resizable()
                    .frame(width: 80, height: 80)
            }
            // 닉네임
            VStack(alignment: .leading, spacing: 10) {
                Text(userDefaults.string(forKey: "nickname") ?? "닉네임")
                    .font(.title4_semibold)
                    .foregroundStyle(.primaryGray)
                Text("누적 거리: \(myPageVM.getTotalDistance())")
                Text("최근 러닝: \(myPageVM.lastRunning())")
            }
            .font(.caption_regular)
            .foregroundStyle(.quaternaryGray)
            
            Spacer()
            
            Button {
                
            } label: {
                Image("edit_profile")
            }

        }
    }
    
    @ViewBuilder
    func recentActivity() -> some View {
        VStack(spacing: 20) {
            HStack {
                Text("최근 활동")
                    .font(.title5_bold)
                    .foregroundStyle(.primaryGray)
                Spacer()
                Button {
                    navigation.path.append(PostCardList.id)
                } label: {
                    Text("더보기")
                        .font(.caption_regular)
                        .foregroundStyle(.quaternaryGray)
                }
            }
            
            // post card
            if let record = myPageVM.user.latest_running_record_nullable {
                PostCard(runningRecord: record)
            }
        }
    }
}

#Preview {
    MyTab()
}
