//
//  SessionTab.swift
//  RunUs
//
//  Created by 가은 on 12/4/24.
//

import SwiftUI

struct SessionTab: View {
    @State private var selectedDateIndex: Int = 0
    
    var body: some View {
        ZStack {
            Color.primaryBG.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                navigationBar()
                week()
                    .padding(.leading, 16)
                filter()
                    .padding(.horizontal, 16)
                Spacer()
            }
        }
    }
    
    // top navigation bar
    @ViewBuilder
    private func navigationBar() -> some View {
        VStack(spacing: 0) {
            HStack {
                Text("러닝세션 찾기")
                    .font(.title5_bold)
                Spacer()
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 14, height: 14)
            }
            .foregroundStyle(.primaryGray)
            .padding(16)
            Divider()
        }
    }
    
    // date filter
    @ViewBuilder
    private func week() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Array(DateManager.shared.getDayTodayTo7days().enumerated()), id: \.element.day) { index, element in
                    Button {
                        selectedDateIndex = index
                    } label: {
                        dayItem(days: element.day, weekday: element.weekday, selected: index == selectedDateIndex)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func dayItem(days: String, weekday: String, selected: Bool) -> some View {
        VStack {
            Text(days)
                .font(.body1_bold)
                .foregroundStyle(selected ? .white : .primaryGray)
            Text(weekday)
                .font(.caption_regular)
                .foregroundStyle(selected ? .white : .tertiaryGray)
        }
        .frame(width: 44, height: 44)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(selected ? .primary400 : .clear)
        )
    }
    
    // category filter
    @ViewBuilder
    private func filter() -> some View {
        HStack {
            filterItem(text: "내 크루")
            filterItem(text: "게스트 참가")
            filterItem(text: "페이스")
        }
    }
    
    @ViewBuilder
    private func filterItem(text: String) -> some View {
        HStack(spacing: 8) {
            Text(text)
                .font(.body1_medium)
                .foregroundStyle(.tertiaryGray)
            if text == "페이스" {
                Image("arrow_down")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.quaternaryGray)
            }
        }
        .frame(height: 24)
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gray400, lineWidth: 1)
        )
    }
}

#Preview {
    SessionTab()
}
