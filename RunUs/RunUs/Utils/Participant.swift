//
//  AggregateParticipants.swift
//  RunUs
//
//  Created by byungjik on 10/31/24.
//

import SwiftUI

struct Participant: View {
    let nikName: String
    let profileImage: String?
    var level: Int = 1
    var totalDistance: Int?
    var currentDistance: Int = 0
    var averagePace: Int?
    
    var body: some View {
        GeometryReader { geometry in
            HStack{
                
                //프로필이 없을 경우 기본 프로필 사용
                generateProfileImage(imageUrl: profileImage)
                    .frame(width: 40, height: 40)
                
                //닉네임 및 러닝 정보
                VStack(alignment: .leading) {
                    Text(nikName)
                        .foregroundStyle(.primaryGray)
                        .font(.title5_medium)
                    if totalDistance != nil {
                        Text("Lv\(level) • \(totalDistance ?? 0)km")
                            .foregroundStyle(.gray500)
                            .font(.caption_regular)
                    }
                }
                .frame(width: geometry.size.width * 0.25, alignment: .leading)
                .padding(.horizontal, 24)
                
                // 페이스
                if averagePace != nil {
                    VStack {
                        Text("\(averagePace ?? 0)")
                            .foregroundStyle(.primaryGray)
                            .font(.title5_medium)
                        Text("평균 페이스")
                            .foregroundStyle(.gray500)
                            .font(.caption_regular)
                    }
                    .padding(.trailing, 20)
                }
                Spacer()
                
                // 캐릭터
                Image("character_default")
            }
        }
        
    }
    
    @ViewBuilder
    func generateProfileImage(imageUrl: String?) -> some View {
        if let profile = imageUrl {
            AsyncImage(url: URL(string: profile))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        } else {
            Image("default_user_profile")
                .resizable()
        }
    }
}

#Preview {
    Participant(nikName: "최강 성훈", profileImage: "", level: 1, totalDistance: 12)
}
