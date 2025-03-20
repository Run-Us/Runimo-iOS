//
//  SessionCard.swift
//  RunUs
//
//  Created by 가은 on 12/5/24.
//

import SwiftUI

struct SessionCard: View {
    let sessionCardData: SessionCardInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if !sessionCardData.top_message.isEmpty {
                Text(sessionCardData.top_message)
                    .font(.body2_medium)
                    .foregroundStyle(.primary400)
            }
            // title과 description는 서버와의 협의를 통해 변경될 수 있음 (디자인과 명세가 일치하지 않음)
            Text(sessionCardData.title)
                .font(.title5_bold)
            Text(sessionCardData.description)
                .font(.body1_bold)
            Text("페이스 \(sessionCardData.pace_list.map{RunningPace(rawValue: $0)!.description}.joined(separator: " - "))")
                .font(.body1_medium)
                .foregroundStyle(.gray400)
            creator(isCreator: sessionCardData.top_message != "게스트 모집 중")
        }
        .foregroundStyle(.primaryGray)
        .padding(.horizontal, 16)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.primaryFill)
                .stroke(.secondaryFill, lineWidth: 1)
        )
    }
    
    @ViewBuilder
    private func creator(isCreator: Bool) -> some View {
        // top message에 따라 생성자 또는 생성 크루를 보여줌
        let owner: (profileImage: String?, name: String) = isCreator ?
        (sessionCardData.created_by.profile_image, sessionCardData.created_by.nickname) :
        (sessionCardData.crew.profile_image, sessionCardData.crew.name)
        
        HStack(spacing: 8) {
            if let profile = owner.profileImage {
                AsyncImage(url: URL(string: profile))
                    .clipShape(Circle())
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle().stroke(.primary200, lineWidth: 1)
                    )
            } else {
                Image(isCreator ? "default_user_profile" : "crew_default_profile")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(.primary200, lineWidth: 1)
                    )
            }
            
            Text(owner.name)
            Spacer()
            Text("참가 인원: \(sessionCardData.participant_count)명")
        }
        .font(.caption_regular)
    }
}

#Preview {
    SessionCard(sessionCardData: SessionCardInfo(runing_public_id: "", top_message: "‘올공특공대’ 정기런", title: "", description: "", start_at: "", pace_list: [], participant_count: 1, created_by: SessionCreator(nickname: "생성자", profile_image: nil), crew: SessionCrew(crew_public_id: "", profile_image: nil, name: "크루명")))
}
