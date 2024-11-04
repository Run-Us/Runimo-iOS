//
//  JoinGroupRunPage.swift
//  RunUs
//
//  Created by byeoungjik on 9/22/24.
//

import SwiftUI

struct JoinGroupRunPage: View {
    @StateObject var participationService = ParticipationService()
    @ObservedObject var RunningSession: RunningSessionService
    @State var text: String = ""
    @State var isValid: Bool = true
    @FocusState private var isTextFieldFocused: Bool
    var body: some View {
        ZStack {
            Color.tone
            VStack {
                PasscodeGenerator(passcode: $text, isValid: $isValid, isInitialize: text.isEmpty, passCodeMode: true)
                    .onTapGesture {
                        print("on tap \(isTextFieldFocused)")
                        isTextFieldFocused = true
                    }
                Text("생성된 대기방의 인증코드 4자리를 입력해주세요.")
                    .font(.body2_medium)
                    .foregroundStyle(.gray500)
                TextField("", text: $text)
                    .foregroundStyle(.white)
                    .focused($isTextFieldFocused)
                    .frame(width: 100, height: 50)
                    .opacity(1)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    JoinGroupRunPage(RunningSession: RunningSessionService())
}
