//
//  FindCrewPage.swift
//  RunUs
//
//  Created by 가은 on 12/2/24.
//

import SwiftUI

struct FindCrewPage: View {
    @State private var showCreateCrewPage: Bool = false
    @State private var searchText: String = ""
    private let tagList: [String] = ["동네 친구", "또래 친구", "대회 준비", "직장인", "학생", "MBTI"]
    var crewList: [CrewCard] = [CrewCard(crew_public_id: "1", title: "Run With Us", profileImage: nil, location: "서울 광진구", memberCount: 10, crewType: "동네 친구", createdAt: ""),CrewCard(crew_public_id: "1", title: "Run With Us", profileImage: nil, location: "서울 광진구", memberCount: 10, crewType: "동네 친구", createdAt: "")] // 더미
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Color.primaryBG
                    .ignoresSafeArea()
                VStack {
                    searchBar()
                    crewFilter()
                    crewCardList()
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                createCrewButton()
            }
            .navigationDestination(isPresented: $showCreateCrewPage) {
                CreateCrew1TagTypePage()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 8) {
                        Button {
                            // TODO: Add Action
                        } label: {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .frame(width: 8, height: 14)
                                .foregroundStyle(.primaryGray)
                        }
                        .frame(width: 14)
                        Text("크루 찾기")
                            .font(.body1_medium)
                            .foregroundStyle(.primaryGray)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // TODO: Add Action
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .foregroundStyle(.primaryGray)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func searchBar() -> some View {
        TextField(
            "",
            text: $searchText,
            prompt: Text("크루 이름으로 검색")
                .font(.caption_regular)
                .foregroundStyle(.gray400)
        )
        .font(.caption_regular)
        .foregroundStyle(.primaryGray)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.primaryFill)
                .stroke(searchText.isEmpty ? .clear : .gray400, lineWidth: 1)
        )
        .overlay(alignment: .trailing) {
            Image("search")
                .padding(.horizontal, 16)
        }
    }
    
    @ViewBuilder
    private func crewTag(text: String) -> some View {
        Text(text)
            .font(.caption_medium)
            .foregroundStyle(.secondaryGray)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.secondaryBG)
            )
    }
    
    @ViewBuilder
    private func crewFilter() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(tagList, id: \.self) { item in
                    crewTag(text: item)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    @ViewBuilder
    private func crewCard(crew: CrewCard) -> some View {
        HStack(spacing: 24) {
            if let profile = crew.profileImage {
                AsyncImage(url: URL(string: profile))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .frame(width: 60, height: 60)
            } else {
                Image("crew_default_profile")
                    .resizable()
                    .frame(width: 60, height: 60)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(crew.title)
                    .font(.title5_bold)
                    .foregroundStyle(.primaryGray)
                Text("\(crew.location) · \(crew.crewType)")
                Text("크루원 수: \(crew.memberCount)명")
            }
            .font(.caption_regular)
            .foregroundStyle(.tertiaryGray)
            Spacer()
        }
    }
    
    @ViewBuilder
    private func crewCardList() -> some View {
        ForEach(crewList, id: \.crew_public_id) { item in
            VStack {
                Button {
                    // TODO: 화면 전환
                } label: {
                    crewCard(crew: item)
                        .padding(.vertical, 10)
                }
                Divider()
            }
        }
    }
    
    @ViewBuilder
    private func createCrewButton() -> some View {
        Button {
            showCreateCrewPage = true
        } label: {
            Image("plus_floating_button")
                .resizable()
                .frame(width: 80, height: 80)
        }
        .padding(24)
    }
}

#Preview {
    FindCrewPage()
}
