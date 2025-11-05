//
//  FeedbackPage.swift (의견 남기기)
//  Runimo
//
//  Created by 가은 on 6/24/25.
//

import SwiftUI

struct FeedbackPage: View {
    @EnvironmentObject var navigation: NavigationManager
    @EnvironmentObject var mypageVM: MyPageViewModel
    @State private var feedbackScoreIndex: Int = -1
    @State private var feedbackText: String = ""
    @FocusState private var isEditorFocused: Bool
    
    private let scoreButtonSizes: [CGFloat] = [36, 32, 28, 28, 32, 36]
    
    var body: some View {
        ZStack {
            Color.primaryBG.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 28) {
                Divider()
                
                Text("러니모에 대한 의견을 알려주세요!")
                    .font(.title4_semibold)
                    .padding(.horizontal, 16)
                
                feedback1View()
                    .padding(.horizontal, 16)
                
                feedback2View()
                    .padding(.horizontal, 16)
                
                Spacer()
                
                CTAButton(text: "제출하기", disabled: feedbackScoreIndex == -1) {
                    mypageVM.sendFeedback(rate: feedbackScoreIndex, contents: feedbackText) { 
                        navigation.path.removeLast()
                    }
                }
            }
            .foregroundStyle(.primaryGray)
        }
        .onTapGesture {
            isEditorFocused = false
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    navigation.path.removeLast()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 8, height: 14)
                        .padding(.horizontal, 5)
                        .foregroundStyle(.primaryGray)
                }
            }
        }
        .toolbarBackground(.primaryBG, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
    
    @ViewBuilder
    private func feedback1View() -> some View {
        VStack(alignment: .leading, spacing: 28) {
            Text("1. 러니모를 통해 습관이 형성되고 있나요?")
                .font(.body1_bold)
            
            VStack(spacing: 12) {
                HStack {
                    Text("전혀 아니다")
                    Spacer()
                    Text("매우 그렇다")
                }
                .font(.body2_medium)
                
                HStack {
                    ForEach(0..<scoreButtonSizes.count, id: \.self) { index in
                        feedbackScoreButton(index: index)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func feedback2View() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("2. 러니모에 대한 의견을 자유롭게 나눠주세요. (선택)")
                .font(.body1_bold)
            
            InputTextArea(title: "", placeholder: "러닝 기능, 보상 시스템, 캐릭터, UI 등 어떤 점이든 자유롭게 의견을 들려주세요.\n보내주신 의견은 서비스 개선에 참고됩니다.", maxCount: 100, contents: $feedbackText, height: 110, isEditorFocused: _isEditorFocused)
        }
    }
    
    @ViewBuilder
    private func feedbackScoreButton(index: Int) -> some View {
        Button {
            feedbackScoreIndex = index
        } label: {
            Image(feedbackScoreIndex == index ? "checkbox_selected" : "checkbox")
                .resizable()
                .frame(width: scoreButtonSizes[index], height: scoreButtonSizes[index])
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    FeedbackPage()
}
