//
//  SessionCard.swift
//  RunUs
//
//  Created by 가은 on 12/5/24.
//

import SwiftUI

struct SessionCard: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("‘올공특공대’ 정기런")
                .font(.body2_medium)
                .foregroundStyle(.primary400)
            Text("오후 4시 30분, 올림픽공원 평화의 문")
                .font(.title5_bold)
            Text("같이 45분 뛰어봐요")
                .font(.body1_bold)
            Text("페이스 5’30” - 6’00” - 빠른 걸음")
                .font(.body1_medium)
                .foregroundStyle(.gray400)
            HStack(spacing: 8) {
                Image("circle_profile")
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("생성한 사용자 이름")
                Spacer()
                Text("참가 인원: 2명")
            }
            .font(.caption_regular)
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
}

#Preview {
    SessionCard()
}
