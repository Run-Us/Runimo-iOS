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
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Color.primaryBG
                    .ignoresSafeArea()
                VStack {
                    searchBar()
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
        TextField("크루 이름으로 검색", text: $searchText)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.primaryFill)
            )
            .overlay(alignment: .trailing) {
                Image("search")
                    .padding(.horizontal, 16)
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
