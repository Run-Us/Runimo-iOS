//
//  Withdraw1Page.swift (탈퇴 사유 입력)
//  Runimo
//
//  Created by 가은 on 6/24/25.
//

import SwiftUI

struct Withdraw1Page: View {
    @EnvironmentObject var navigation: NavigationManager
    @EnvironmentObject var sharedData: SharedData
    @EnvironmentObject var mypageVM: MyPageViewModel
    @State private var selectedIndex: Int = -1
    @State private var inputReason: String = ""
    @FocusState private var isEditorFocused: Bool
    
    var body: some View {
        ZStack {
            Color.primaryBG.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 24) {
                Divider()
                Text("탈퇴하는 이유가 무엇인가요?")
                    .font(.title4_semibold)
                    .foregroundStyle(.primaryGray)
                    .padding(.horizontal, 16)
                ForEach(Array(WithdrawReason.allCases.enumerated()), id: \.element) { index, text in
                    item(title: text.description, index: index)
                }
                .padding(.horizontal, 16)
                
                InputTextArea(title: "", placeholder: "탈퇴 사유를 자유롭게 작성해주세요.", maxCount: 100, contents: $inputReason, height: 110, isEditorFocused: _isEditorFocused)
                    .padding(.horizontal, 16)
                    .opacity(selectedIndex == WithdrawReason.allCases.count - 1 ? 1 : 0)
                
                
                Spacer()
                CTAButton(text: "다음", disabled: selectedIndex == -1 || (selectedIndex == WithdrawReason.allCases.count - 1 && inputReason.isEmpty)) {
                    
                    if let value = WithdrawReason(rawValue: selectedIndex) {
                        mypageVM.withdrawReason = (value.requestText, inputReason)
                    }
                    navigation.path.append(Withdraw2Page.id)
                }
            }
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
    private func item(title: String, index: Int) -> some View {
        HStack(spacing: 12) {
            Button {
                selectedIndex = index
            } label: {
                Image(selectedIndex == index ? "checkbox_selected" : "checkbox")
                Text(title)
                    .font(.body1_bold)
                    .foregroundStyle(.secondaryGray)
            }
            .buttonStyle(.plain)
            Spacer()
        }
    }
}

#Preview {
    Withdraw1Page()
}


enum WithdrawReason: Int, CaseIterable {
    case reason0
    case reason1
    case reason2
    case reason3
    case reason4
    case reason5
    case reason6
    
    var requestText: String {
        switch self {
        case .reason0: return "NOT_ENOUGH_CHARACTERS"
        case .reason1: return "NO_LONGER_NEEDED"
        case .reason2: return "RECORD_NOT_EXPECTED"
        case .reason3: return "COMPLEX_USAGE"
        case .reason4: return "USING_OTHER_SERVICE"
        case .reason5: return "PRIVACY_CONCERN"
        case .reason6: return "OTHER"
        }
    }
    
    var description: String {
        switch self {
        case .reason0: return "수집할 캐릭터가 부족해요"
        case .reason1: return "러닝 목표에 도움이 되지 않아요"
        case .reason2: return "기록 기능이 기대와 달라요"
        case .reason3: return "앱 사용이 복잡하거나 불편해요"
        case .reason4: return "다른 러닝 앱을 사용하고 있어요"
        case .reason5: return "개인정보가 걱정돼요"
        case .reason6: return "기타 (직접 입력)"
        }
    }
}
