//
//  JoinGroupRunPage.swift
//  RunUs
//
//  Created by byeoungjik on 9/22/24.
//

import SwiftUI

struct JoinGroupRunPage: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var participationService = ParticipationService()
    @ObservedObject var runningSession: RunningSessionService
    @State var passcode: String
    @State var isValid: Bool = true
    @State var showWaitingGroupRunPage: Bool = false

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Color.tone
                    VStack {
                        VStack {
                            PasscodeGenerator(passcode: $passcode, isValid: $isValid, isInitialize: passcode.isEmpty, writeMode: true)
                                .padding(.horizontal, 36)
                            
                            Text("생성된 대기방의 인증코드 4자리를 입력해주세요.")
                                .font(.body2_medium)
                                .foregroundStyle(.quaternaryGray)
                        }
                        .padding(.vertical, 72)
                        
                        Spacer()
                        Divider()
                        Button {
                            showWaitingGroupRunPage = true
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
                    .padding(.vertical, 52)
                }
                .ignoresSafeArea()
            }
        }
        .navigationDestination(isPresented: $showWaitingGroupRunPage, destination: {
            WaitGroupRunPage(passcode: passcode, runningSession: runningSession)
        })
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 8, height: 14)
                        Text("대기방")
                            .font(.body1_medium)
                    }
                    .foregroundStyle(.primaryGray)
                }
            }
        }
    }
}

#Preview {
    JoinGroupRunPage(runningSession: RunningSessionService(), passcode: "0000")
}
