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
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    JoinGroupRunPage(RunningSession: RunningSessionService())
}
