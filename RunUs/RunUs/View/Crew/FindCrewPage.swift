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
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Color.primaryBG
                    .ignoresSafeArea()
                VStack {
                    searchBar()
                    crewFilter()
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
