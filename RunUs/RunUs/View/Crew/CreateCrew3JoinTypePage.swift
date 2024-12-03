//
//  CreateCrew3JoinTypePage.swift
//  RunUs
//
//  Created by 가은 on 12/3/24.
//

import SwiftUI

struct CreateCrew3JoinTypePage: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedJoinTypeIndex: Int = 0
    private let joinTypeString: [[String]] = [
        ["즉시 가입", "RunUS 서비스를 사용하는 누구나 바로 가입할 수 있어요."],
        ["신청 가입", "가입 질문에 답변하여 신청하고, 검토 후 가입이 승인돼요."]
    ]
    @State private var answer: String = ""
    @FocusState private var isEditorFocused: Bool
    @State private var showCrewHomePage: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primaryBG
                    .ignoresSafeArea()
                VStack(alignment: .leading) {
                    Divider()
                        .frame(height: 0.5)
                        .background(.secondaryFill)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("마지막이에요!")
                            .font(.title5_bold)
                            .foregroundStyle(.primaryGray)
                        Text("크루 가입 방식을 선택해주세요")
                            .font(.body2_medium)
                            .foregroundStyle(.quaternaryGray)
                    
                        HStack {
                            Text("가입 방식")
                                .font(.body1_bold)
                            Spacer()
                            Text(joinTypeString[selectedJoinTypeIndex][0])
                                .font(.body1_medium)
                        }
                        .foregroundStyle(.secondaryGray)
                        .padding(.top, 32)
                        
                        ForEach(Array(joinTypeString.enumerated()), id: \.offset) { index, join in
                            Button {
                                selectedJoinTypeIndex = index
                            } label: {
                                TypeCheckbox(selectedBox: selectedJoinTypeIndex, typeIdx: index, title: join[0], explanation: join[1])
                            }
                            .buttonStyle(.plain)
                        }
                        
                        if selectedJoinTypeIndex == 1 {
                            InputTextArea(title: "가입 질문", placeholder: "같이 달릴 러너를 위해, 크루에 대해 간단히 소개해주세요", maxCount: 300, contents: $answer, height: 110, isEditorFocused: _isEditorFocused)
                                .padding(.top, 32)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 24)
                    
                    Spacer()
                    CTAButton(text: "크루 만들기", disabled: selectedJoinTypeIndex==1 && answer.isEmpty) {
                        // TODO: Create Crew API
                        showCrewHomePage = true
                    }
                    .navigationDestination(isPresented: $showCrewHomePage) {
                        CrewHomePage()
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 8, height: 14)
                            .foregroundStyle(.primaryGray)
                    }
                    .frame(width: 14)
                }
            }
        }
    }
}

#Preview {
    CreateCrew3JoinTypePage()
}
