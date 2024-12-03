//
//  CreateCrew2DetailPage.swift
//  RunUs
//
//  Created by 가은 on 12/3/24.
//

import SwiftUI

struct CreateCrew2DetailPage: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedProfile: UIImage? = nil
    @FocusState private var isEditorFocused: Bool
    @State private var crewName: String = ""
    @State private var crewExplanation: String = ""
    @State private var activeArea: String = ""
    @State private var showNextJoinPage: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color.primaryBG
                    .ignoresSafeArea()
                VStack {
                    Divider()
                        .frame(height: 0.5)
                        .background(.secondaryFill)
                    ScrollView {
                        VStack(spacing: 32) {
                            VStack(spacing: 5) {
                                Text("크루를 만들어볼까요?")
                                    .font(.title5_bold)
                                    .foregroundStyle(.primaryGray)
                                Text("크루의 프로필을 등록해주세요")
                                    .font(.body2_medium)
                                    .foregroundStyle(.quaternaryGray)
                            }
                            
                            profileImage()
                            InputTextArea(title: "크루명", placeholder: "크루의 이름을 입력해주세요", maxCount: 10, contents: $crewName, height: 47, isEditorFocused: _isEditorFocused)
                            InputTextArea(title: "상세 소개말", placeholder: "같이 달릴 러너를 위해, 크루에 대해 간단히 소개해주세요", maxCount: 300, contents: $crewExplanation, height: 110, isEditorFocused: _isEditorFocused)
                            InputTextArea(title: "활동 지역", placeholder: "예시: 서울 마포구", maxCount: 10, contents: $activeArea, height: 47, isEditorFocused: _isEditorFocused)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 24)
                    
                    CTAButton(text: "다음", disabled: crewName.isEmpty || crewExplanation.isEmpty || activeArea.isEmpty) {
                        showNextJoinPage = true
                    }
                    .navigationDestination(isPresented: $showNextJoinPage) {
                        CreateCrew3JoinTypePage()
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
            .toolbarBackground(.primaryBG, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .onTapGesture {
            isEditorFocused = false
        }
    }
    
    @ViewBuilder
    func profileImage() -> some View {
        Button {
        } label: {
            Image(uiImage: selectedProfile ?? UIImage(named: "default_user_profile")!)   // TODO: change to crew default image
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 52))
        }
        .overlay(alignment: .bottomTrailing) {
            Image("plus_profile_button")
        }
        .padding(36)
    }
}

#Preview {
    CreateCrew2DetailPage()
}
