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
            Text(sessionCardData.top_message)
                .font(.body2_medium)
                .foregroundStyle(.primary400)
            Text("오후 4시 30분, 올림픽공원 평화의 문")
                .font(.title5_bold)
            Text("같이 45분 뛰어봐요")
                .font(.body1_bold)
            Text("페이스 5’30” - 6’00” - 빠른 걸음")
                .font(.body1_medium)
                .foregroundStyle(.gray400)
            creator(isCreator: sessionCardData.top_message == "게스트 모집 중")
        }
        .foregroundStyle(.primaryGray)
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
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
    SessionCard(sessionCardData: SessionCardInfo(runing_public_id: "", top_message: "‘올공특공대’ 정기런", title: "", description: "", start_at: "", pace: [], participant_count: 1, created_by: SessionCreator(nickname: "생성자", profile_image: nil), crew: SessionCrew(crew_public_id: "", profile_image: nil, name: "크루명")))
}
