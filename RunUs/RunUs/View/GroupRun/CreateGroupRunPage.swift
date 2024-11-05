//
//  CreateGroupRunPage.swift
//  RunUs
//
//  Created by byeoungjik on 9/16/24.
//

import SwiftUI

struct CreateGroupRunPage: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var mapVM: MapViewModel
    @EnvironmentObject var runVM: RunningViewModel
    @ObservedObject var runningSession: RunningSessionService
    @StateObject var participationService = ParticipationService()
    @ObservedObject private var pollingManager = PollingManager(pollingInterval: 2.0)
    @State var showStartGroupRunAlter = false
    @State var startGroupRun = false
    @State var passcode: String
    @State private var isValid: Bool = true
    @State var aggregateParticipants: [AggregateParticipants]?
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.tone)
                VStack(alignment: .center) {
                    // goal
                    Text("더 많은 보상 받아보세요!")
                        .font(.title4_semibold)
                        .foregroundStyle(.gray900)
                        .padding(.top, 80)
                    
                    Button(action: {
                        
                    }, label: {
                        HStack {
                            Image("goal_flag")
                                .frame(width: 24, height: 24)
                            Text("목표 추가하기")
                                .font(.title5_bold)
                                .foregroundStyle(.gray900)
                        }
                        .padding(EdgeInsets(top: 16, leading: 18, bottom: 16, trailing: 18))
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray300, lineWidth: 1)
                        )
                    })
                    // 인증번호
                    VStack {
                        PasscodeGenerator(passcode: $passcode, isValid: $isValid)
                            .padding(.bottom, 5)
                        Text("러너에게 인증코드 4자리를 보여주세요")
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
                    Divider()
                    Button(action: {
                        showStartGroupRunAlter = true
                    }, label: {
                        Text("달리기 시작!")
                            .font(.title5_bold)
                            .foregroundStyle(.white)
                            .frame(width: 361, height: 56)
                    })
                    .background(.primary400)
                    .cornerRadius(8)
                    .padding(8)
                    
                }
                .padding(.vertical, 36)
            }
            .ignoresSafeArea()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: 10) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 8, height: 14)
                    })
                    Text("대기방")
                        .font(.body1_medium)
                }
            }
        }
        .foregroundStyle(.gray900)
        .popup(
          isPresented: $showStartGroupRunAlter,
          title: "그룹 달리기를 시작할까요?",
          subtitle: "user_name님을 포함해 총 12명이 모였어요",
          buttonText: "시작하기",
          buttonColor: .primary400,
          cancelAction: {
              showStartGroupRunAlter = false
          },
          buttonAction: {
              dismiss()
              startRun()
              startGroupRun = true
          })
        .onAppear {
            pollingManager.startPolling {
                self.pollingAction()
            }
        }
        .onDisappear {
            pollingManager.stopPolling()
        }
        .navigationDestination(isPresented: $startGroupRun, destination:{
            RunningPage()
        })
    }
    
    func startRun() {
        let startRunningInfo = [
            "userId": UserDefaults.standard.string(forKey: "userId") ?? "",
            "runningId": runningSession.latestSessionResponse?.payload.runningKey ?? "",
            "runningKey": runningSession.latestSessionResponse?.payload.runningKey ?? ""
        ]
        WebSocketService.sharedSocket.sendMessage(body: startRunningInfo, destination: "/app/runnings/start")
        startGroupRun = true
    }
    
    func pollingAction() {
        participationService.getParticipantList(runningId: runningSession.latestSessionResponse?.payload.runningKey ?? "") { success, data in
            if !success {
                print("참가자 정보 불러오기 실패")
            }
            else {
                aggregateParticipants = data
            }
            
        }
    }
}

#Preview {
    CreateGroupRunPage(mapVM: .init(), runningSession: RunningSessionService(), passcode: "2312")
}
