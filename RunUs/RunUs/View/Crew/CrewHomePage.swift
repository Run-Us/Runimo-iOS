//
//  CrewHomePage.swift
//  RunUs
//
//  Created by 가은 on 12/4/24.
//

import SwiftUI

struct CrewHomePage: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
            Color.primaryBG.ignoresSafeArea()
            ScrollView {
                crewProfile()
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                SegmentedPicker(selectedTab: $selectedTab, type: ["일정","피드","크루원"])
                switch selectedTab {
                case 0: EmptyView()     // 일정
                case 1: EmptyView()     // 피드
                default: EmptyView()    // 크루원
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 8, height: 14)
                            .foregroundStyle(.primaryGray)
                    }
                    .frame(width: 14)
                    Text("Run with US 공식크루")
                        .font(.body1_medium)
                        .foregroundStyle(.primaryGray)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // TODO: Add Action
                } label: {
                    Image("vertical_dots")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.primaryGray)
                        .frame(width: 20, height: 20)
                }
            }
        }
        .toolbarBackground(.primaryBG, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
    
    @ViewBuilder
    private func crewProfile() -> some View {
        HStack(spacing: 24) {
            Image("crew_default_profile")
                .resizable()
                .frame(width: 80, height: 80)
            VStack(alignment: .leading, spacing: 8) {
                Text("Run US 공식크루")
                    .font(.title4_semibold)
                    .foregroundStyle(.primaryGray)
                Text("Run with Us! 런어스의 공식크루 입니다.Run with Us! 런어스의 공식크루 입니다.")
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text("크루원 100명 · 동네친구")
            }
            .font(.body2_medium)
            .foregroundStyle(.quaternaryGray)
            Spacer()
        }
    }
}

#Preview {
    CrewHomePage()
}
