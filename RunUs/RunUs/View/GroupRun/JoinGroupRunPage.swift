//
//  JoinGroupRunPage.swift
//  RunUs
//
//  Created by byeoungjik on 9/22/24.
//

import SwiftUI

struct JoinGroupRunPage: View {
    @State var noticeBar = NoticeBar(noticeContent: .constant("곧 그룹 러닝이 시작됩니다!"))
    @StateObject var participationService = ParticipationService()
    @ObservedObject var RunningSession: RunningSessionService
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    MapPage(mapVM: .init())
                    VStack {
                        noticeBar
                            .frame(width: geometry.size.width)
                            .padding(.top, 40)
                        Spacer()
                    }
                }
                if let participantsList = participationService.aggregateParticipants{
                    Text("참가자 목록을 불러오는 중...")
                        .onAppear {
                            
                        }
                } else {
                }
            }
        }
    }
}

#Preview {
    JoinGroupRunPage(RunningSession: RunningSessionService())
}
