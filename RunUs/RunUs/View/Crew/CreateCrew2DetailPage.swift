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
                            textField(title: "크루명", contents: $crewName, placeholder: "크루의 이름을 입력해주세요", maxCount: 10)
                            textField(title: "상세 소개말", contents: $crewExplanation, placeholder: "같이 달릴 러너를 위해, 크루에 대해 간단히 소개해주세요", maxCount: 300)
                            textField(title: "활동 지역", contents: $activeArea, placeholder: "예시: 서울 마포구", maxCount: 10)
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
    
    @ViewBuilder
    func textField(title: String, contents: Binding<String>, placeholder: String, maxCount: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.body1_bold)
            ZStack(alignment: .topLeading) {
                // input text
                TextEditor(text: contents)
                    .scrollContentBackground(.hidden)
                    .focused($isEditorFocused)
                    .font(.body2_medium)
                    .padding(8)
                    .frame(height: title == "상세 소개말" ? 110 : 47)
                    .foregroundColor(.primaryGray)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(contents.wrappedValue.count > 0 ? .secondaryGray : .quaternaryGray)
                    )
                // placeholder
                if contents.wrappedValue.isEmpty {
                    Text(placeholder)
                        .font(.body2_medium)
                        .foregroundStyle(.gray400)
                        .padding(EdgeInsets(top: 15, leading: 12, bottom: 15, trailing: 12))
                }
            }

            // 글자수
            HStack {
                Spacer()
                Text("\(contents.wrappedValue.count)/\(maxCount)")
                    .foregroundStyle(.gray400)
                    .font(.caption_regular)
            }
        }
    }
}

#Preview {
    CreateCrew2DetailPage()
}
