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
    @State var passcode: String
    @State var isValid: Bool = true
//    @FocusState private var isTextFieldFocused: Bool
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color.tone
                    VStack(spacing: 25) {
                        PasscodeGenerator(passcode: $passcode, isValid: $isValid, isInitialize: passcode.isEmpty, writeMode: true)
                            .padding(.top, 100)
                        
                        Text("생성된 대기방의 인증코드 4자리를 입력해주세요.")
                            .font(.body2_medium)
                            .foregroundStyle(.gray500)
                        
                        Spacer()
                        Divider()
                        Button {
                            print(passcode)
                        } label: {
                            Text("입장하기")
                                .font(.title5_bold)
                                .foregroundStyle(.white)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .frame(width: geometry.size.width - 32, height: 56)
                                )
                        }
                        .padding(.vertical)
                        
                    }
                    .padding(.vertical, 50)
                }
                .ignoresSafeArea()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .frame(width: 8, height: 14)
                            Text("대기방")
                                .font(.body1_medium)
                        }
                        .foregroundStyle(.gray900)
                    }
                }
            }
        }
    }
}

#Preview {
    JoinGroupRunPage(RunningSession: RunningSessionService(), passcode: "0000")
}
