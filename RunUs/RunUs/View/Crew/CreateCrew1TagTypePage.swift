//
//  CreateCrew1TagTypePage.swift
//  RunUs
//
//  Created by 가은 on 12/2/24.
//

import SwiftUI

struct CreateCrew1TagTypePage: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedCrewIndex: Int = 0
    private let crewTypeString: [[String]] = [
        ["동네 친구", "내 동네와 비슷한 러너가 모여 같이 달려요."],
        ["또래 친구", "비슷한 나이대의 러너들과 함께 공감하며 달려요."],
        ["직장인", "일과 후 스트레스를 날려버릴 직장인 러너들과 함께해요."],
        ["학생", "학교, 공부 얘기도 나누며 또래 학생 러너들과 달려요."],
        ["MBTI", "성격이 잘 맞는 러너들과 함께 재밌게 달려봐요!"],
        ["대회 준비", "목표가 같은 러너들과 함께 더 멀리, 더 빠르게 달려요."]
    ]
    @State private var showNextJoinPage: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primaryBG
                    .ignoresSafeArea()
                VStack(alignment: .leading) {
                    Divider()
                    VStack(alignment: .leading, spacing: 8) {
                        Text("어떤 성격의 크루를 만들고 싶은가요?")
                            .font(.title5_bold)
                            .foregroundStyle(.primaryGray)
                        Text("크루의 테마를 지정해주세요")
                            .font(.body2_medium)
                            .foregroundStyle(.quaternaryGray)
                        ForEach(Array(crewTypeString.enumerated()), id: \.offset) { index, crew in
                            Button {
                                selectedCrewIndex = index
                            } label: {
                                TypeCheckbox(selectedBox: selectedCrewIndex, typeIdx: index, title: crew[0], explanation: crew[1])
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 24)
                    Spacer()
                    CTAButton(text: "다음", disabled: false) {
                        showNextJoinPage = true
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .foregroundStyle(.primaryGray)
                    }
                }
            }
            .navigationDestination(isPresented: $showNextJoinPage) {
                CreateCrew2DetailPage(crew: nil, showEditCrewInfoIndex: .constant(-1))
            }
        }
    }
}

#Preview {
    CreateCrew1TagTypePage()
}
