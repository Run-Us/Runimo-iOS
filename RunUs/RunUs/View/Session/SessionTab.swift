//
//  SessionTab.swift
//  RunUs
//
//  Created by 가은 on 12/4/24.
//

import SwiftUI

enum RunningPace: String {
    case above500 = "ABOVE_500"
    case pace500 = "500"
    case pace530 = "530"
    case pace600 = "600"
    case pace630 = "630"
    case pace700 = "700"
    case pace730 = "730"
    case pace800 = "800"
    case fastWalk = "FAST_WALK"
    
    var description: String {
        switch self {
        case .above500: return "5’00” 이하"
        case .fastWalk: return "빠른 걸음"
        default: return "\(self.rawValue.dropLast(2))’\(self.rawValue.dropFirst())”"
        }
    }
}

struct SessionTab: View {
    @State private var selectedDateIndex: Int = 0
    @State private var showSessionDetailPage: Bool = false
    
    var body: some View {
        ZStack {
            Color.primaryBG.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                navigationBar()
                week()
                    .padding(.leading, 16)
                filter()
                    .padding(.horizontal, 16)
                sessionCardList()
                    .padding(.horizontal, 16)
            }
        }
    }
    
    // top navigation bar
    @ViewBuilder
    private func navigationBar() -> some View {
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
    
    // date filter
    @ViewBuilder
    private func week() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Array(DateManager.shared.getDayTodayTo7days().enumerated()), id: \.element.day) { index, element in
                    Button {
                        selectedDateIndex = index
                    } label: {
                        dayItem(days: element.day, weekday: element.weekday, selected: index == selectedDateIndex)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func dayItem(days: String, weekday: String, selected: Bool) -> some View {
        VStack {
            Text(days)
                .font(.body1_bold)
                .foregroundStyle(selected ? .white : .primaryGray)
            Text(weekday)
                .font(.caption_regular)
                .foregroundStyle(selected ? .white : .tertiaryGray)
        }
        .frame(width: 44, height: 44)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(selected ? .primary400 : .clear)
        )
    }
    
    // category filter
    @ViewBuilder
    private func filter() -> some View {
        HStack {
            filterItem(text: "내 크루")
            filterItem(text: "게스트 참가")
            filterItem(text: "페이스")
        }
    }
    
    // TODO: 필터 적용에 따른 뷰 바꾸기 (JIS-17)
    @ViewBuilder
    private func filterItem(text: String) -> some View {
        HStack(spacing: 8) {
            Text(text)
                .font(.body1_medium)
                .foregroundStyle(.tertiaryGray)
            if text == "페이스" {
                Image("arrow_down")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.tertiaryGray)
            }
        }
        .frame(height: 24)
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gray400, lineWidth: 1)
        )
    }
    
    @ViewBuilder
    private func sessionCardList() -> some View {
        // TODO: API 연결 후 리스트로 변경
        // 확인용 더미데이터 넣어놓음
        ScrollView {
            VStack(spacing: 12) {
                // 테스트용으로 하나만 버튼 이벤트 추가
                Button {
                    showSessionDetailPage = true
                } label: {
                    SessionCard(sessionCardData: SessionCardInfo(runing_public_id: "", top_message: "", title: "제목", description: "설명", start_at: "", pace: ["500","600"], participant_count: 3, created_by: SessionCreator(nickname: "생성자2", profile_image: nil), crew: SessionCrew(crew_public_id: "", profile_image: nil, name: "크루2")))
                }
                .navigationDestination(isPresented: $showSessionDetailPage) {
                    SessionDetailPage()
                }
                SessionCard(sessionCardData: SessionCardInfo(runing_public_id: "", top_message: "‘올공특공대’ 정기런", title: "제목2", description: "설명2", start_at: "", pace: ["500"], participant_count: 2, created_by: SessionCreator(nickname: "생성자1", profile_image: nil), crew: SessionCrew(crew_public_id: "", profile_image: nil, name: "크루1")))
                SessionCard(sessionCardData: SessionCardInfo(runing_public_id: "", top_message: "게스트 모집 중", title: "제목3", description: "설명3", start_at: "", pace: ["600"], participant_count: 4, created_by: SessionCreator(nickname: "생성자2", profile_image: nil), crew: SessionCrew(crew_public_id: "", profile_image: nil, name: "크루2")))
                
                SessionCard(sessionCardData: SessionCardInfo(runing_public_id: "", top_message: "‘올공특공대’ 번개런", title: "제목4", description: "설명4", start_at: "", pace: ["600"], participant_count: 5, created_by: SessionCreator(nickname: "생성자3", profile_image: nil), crew: SessionCrew(crew_public_id: "", profile_image: nil, name: "크루3")))
            }
        }
    }
}

#Preview {
    SessionTab()
}
