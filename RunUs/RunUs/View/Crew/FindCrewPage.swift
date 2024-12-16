//
//  FindCrewPage.swift
//  RunUs
//
//  Created by 가은 on 12/2/24.
//

import SwiftUI

struct FindCrewPage: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var crewVM: CrewViewModel = CrewViewModel()
    @State private var showCreateCrewPage: Bool = false
    @State private var searchText: String = ""
    
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
                            dismiss()
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
        .navigationBarBackButtonHidden()
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
    private func crewFilter() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(crewVM.tagList.indices, id: \.self) { index in
                    Button {
                        crewVM.selectedTag[index].toggle()
                    } label: {
                        crewTag(index: index)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    @ViewBuilder
    private func crewTag(index: Int) -> some View {
        Text(crewVM.tagList[index])
            .font(.caption_medium)
            .foregroundStyle(crewVM.selectedTag[index] ? .white : .secondaryGray)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(crewVM.selectedTag[index] ? .primary400 : .secondaryBG)
            )
    }
    
    @ViewBuilder
    private func crewCardList() -> some View {
        if isCrewDataEmpty() {
            noCrewDataView()
        } else {
            ScrollView {
                ForEach(crewVM.crewCardData, id: \.crew_public_id) { item in
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
        }
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
    private func noCrewDataView() -> some View {
        VStack(spacing: 8) {
            Text("해당 러닝크루가 없어요")
                .font(.title4_semibold)
                .foregroundStyle(.primaryGray)
            Button {
                crewVM.selectedTag = Array(repeating: false, count: crewVM.tagList.count)
                searchText = ""
            } label: {
                Text("검색 해제하기")
                    .font(.caption_regular)
                    .foregroundStyle(.quaternaryGray)
                    .underline()
            }
        }
        .padding(.vertical, 40)
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
    
    private func isCrewDataEmpty() -> Bool {
        return crewVM.crewCardData.isEmpty
    }
}

#Preview {
    FindCrewPage()
}
