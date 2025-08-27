//
//  MyPage.swift
//  RunUs
//
//  Created by byeoungjik on 9/9/24.
//

import SwiftUI
import Kingfisher

struct MyTab: View {
    @EnvironmentObject var navigation: NavigationManager
    @EnvironmentObject var sharedData: SharedData
    @EnvironmentObject var myPageVM: MyPageViewModel
    let userDefaults = UserDefaults.standard
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                userInfo()
                    .padding(.vertical, 24)
                    .padding(.horizontal, 16)
                
                SegmentedPicker(selectedTab: $myPageVM.selectedTab, type: ["주간","월간"], width: geometry.size.width)
                
                VStack(spacing: 24) {
                    RecordCard()
                    MyGraph()
                        .frame(height: 160)
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
                if let profile = data.profile_image_url {
                    UserDefaults.standard.set(profile, forKey: "profileURL")
                }
            }
        }
        .onChange(of: DateManager.shared.date) { oldValue, newValue in
            myPageVM.getGraphAPI()
        }
        .onChange(of: myPageVM.selectedTab) { _, _ in
            sharedData.dateSheetSelectedIndex = 0
            DateManager.shared.setDateToday()
        }
        .onDisappear {
            myPageVM.selectedTab = 0
        }
    }
    
    @ViewBuilder
    func userInfo() -> some View {
        HStack(spacing: 24) {
            // 프로필 사진
            KFImage(URL(string: myPageVM.user.profile_image_url ?? ""))
                .placeholder {
                    ProgressView()
                }
                .onFailureImage(UIImage(named: "default_user_profile"))
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 32))

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

        }
    }
    
}

#Preview {
    MyTab()
}
