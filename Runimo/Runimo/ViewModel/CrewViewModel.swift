//
//  CrewViewModel.swift
//  RunUs
//
//  Created by 가은 on 12/16/24.
//

import Foundation

class CrewViewModel: ObservableObject {
    let tagList: [String] = ["동네 친구", "또래 친구", "대회 준비", "직장인", "학생", "MBTI"]
    @Published var selectedTag: [Bool] = Array(repeating: false, count: 6)
    @Published var crewCardData: [CrewCard] = [CrewCard(crew_public_id: "1", title: "Run With Us", profileImage: nil, location: "서울 광진구", memberCount: 10, crewType: "동네 친구", createdAt: ""),CrewCard(crew_public_id: "1", title: "Run With Us", profileImage: nil, location: "서울 광진구", memberCount: 10, crewType: "동네 친구", createdAt: "")] // 더미
}
