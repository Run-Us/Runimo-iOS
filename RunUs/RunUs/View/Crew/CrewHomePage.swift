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
        ZStack(alignment: .bottomTrailing) {
            Color.primaryBG.ignoresSafeArea()
            ScrollView {
                crewProfile()
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                
                SegmentedPicker(selectedTab: $selectedTab, type: ["일정","피드","크루원"])
                switch selectedTab {
                case 0: scheduleTab()     // 일정
                case 1: EmptyView()     // 피드
                default: EmptyView()    // 크루원
                }
            }
            createSessionButton()
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
                .padding(.vertical, 10)
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
    
    @ViewBuilder
    private func scheduleTab() -> some View {
        VStack(alignment: .leading, spacing: 24) {
            RecordCard()
                .padding(.top, 20)
            regularRunningSession()
            irregularRunningSession()
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func regularRunningSession() -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 5) {
                Text("다음 정기 러닝세션")
                    .font(.title5_bold)
                    .foregroundStyle(.primaryGray)
                Text("크루장이 생성한 공식 일정이에요")
                    .font(.body2_medium)
                    .foregroundStyle(.quaternaryGray)
            }
            
            Button {
                // TODO: 정기런 만들기
                print("click")
            } label: {
                createRegularButton()
            }
            .padding(.vertical, 40)
        }
    }
    
    @ViewBuilder
    private func createRegularButton() -> some View {
        HStack(spacing: 8) {
            Image("goal_flag")
                .resizable()
                .frame(width: 24, height: 24)
            Text("정기런 만들기")
                .font(.title5_bold)
                .foregroundStyle(.primaryGray)
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.secondaryFill, lineWidth: 1)
        )
    }
    
    @ViewBuilder
    private func irregularRunningSession() -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 5) {
                Text("번개 러닝세션")
                    .font(.title5_bold)
                    .foregroundStyle(.primaryGray)
                Text("크루원이 생성한 번개런에 참여해보세요")
                    .font(.body2_medium)
                    .foregroundStyle(.quaternaryGray)
            }
            
            Text("달리는 크루원이 없나보네요")
                .font(.title4_semibold)
                .foregroundStyle(.primaryGray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
        }
    }
    
    @ViewBuilder
    private func createSessionButton() -> some View {
        Button {
            // TODO: Add Action
        } label: {
            Image("plus_floating_button")
                .resizable()
                .frame(width: 80, height: 80)
        }
        .padding(24)
    }
}

#Preview {
    CrewHomePage()
}
