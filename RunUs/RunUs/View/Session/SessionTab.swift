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
            VStack(spacing: 16) {
                navigationBar()
                week()
                    .padding(.leading, 16)
                Spacer()
            }
        }
    }
    
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
    
    @ViewBuilder
    private func week() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Array(DateManager.shared.getDayTodayTo7days().enumerated()), id: \.element.day) { index, element in
                    Button {
                        selectedDateIndex = index
                    } label: {
                        day(days: element.day, weekday: element.weekday, selected: index == selectedDateIndex)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func day(days: String, weekday: String, selected: Bool) -> some View {
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
}

#Preview {
    SessionTab()
}
