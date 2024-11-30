//
//  WaitGroupRunPage.swift
//  RunUs
//
//  Created by byeoungjik on 11/30/24.
//

import SwiftUI

struct WaitGroupRunPage: View {
    @Environment(\.dismiss) var dismiss
    @State var passcode: String
    @State private var isValid: Bool = true
    @State var aggregateParticipants: [AggregateParticipants]?
    @StateObject var participationService = ParticipationService()
    @ObservedObject var runningSession: RunningSessionService
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.tone)
                VStack {
                    VStack {
                        PasscodeGenerator(passcode: $passcode, isValid: $isValid, writeMode: false)
                            .padding(.bottom, 5)
                        Text("곧 그룹 달리기가 시작됩니다!")
                            .font(.body2_medium)
                            .foregroundStyle(.gray500)
                    }
                    .padding(72)
                    
                    List {
                        if let participants = aggregateParticipants {
                            ForEach(participants.indices, id: \.self) { index in
                                Participant(nikName: participants[index].name, profileImage: participants[index].imgUrl, totalDistance: participants[index].totalDistanceInMeters)
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 36)
                }
                .padding(.top, 52)
            }
            .ignoresSafeArea()
        }
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
        .onAppear {
            PollingManager.shared.startPolling {
                self.pollingAction()
            }
        }
        .onDisappear {
            PollingManager.shared.stopPolling()
        }
    }
    
    
    func pollingAction() {
        participationService.getParticipantList(runningId: runningSession.runningSessionInfo?.runningId ?? "") { success, data in
            if !success {
                print("Failed to get participant list")
            }
            else {
                aggregateParticipants = data
            }
            
        }
    }
}

#Preview {
    WaitGroupRunPage(passcode: "1234", participationService: ParticipationService(), runningSession: RunningSessionService())
}
