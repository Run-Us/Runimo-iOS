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
    @State var showStartGroupRunAlter = false
    @State var showStartAloneRunAlter = false
    @State var showGroupRunCancelAlter = false
    @State var startGroupRun = false
    @State var totalAggregateNum: Int = 0
    @State var passcode: String
    @State private var isValid: Bool = true
    @State var aggregateParticipants: [AggregateParticipants]?
    let nickname = UserDefaults.standard.string(forKey: "nickname") ?? "user_name"
    
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
                    // passcode
                    VStack {
                        PasscodeGenerator(passcode: $passcode, isValid: $isValid, writeMode: false)
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
                        totalAggregateNum = aggregateParticipants?.capacity ?? 0
                        if totalAggregateNum == 0 {
                            showStartAloneRunAlter = true
                        } else {
                            showStartGroupRunAlter = true
                        }
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
                        showGroupRunCancelAlter = true
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
          subtitle: "\(nickname)님을 포함해 총 \(totalAggregateNum)명이 모였어요",
          buttonText: "시작하기",
          buttonColor: .primary400,
          cancelAction: {
              showStartGroupRunAlter = false
          },
          buttonAction: {
              startRun()
              startGroupRun = true
          })
        .popup(
          isPresented: $showStartAloneRunAlter,
          title: "혼자서 달리시나요?",
          subtitle: "아직 입장한 그룹원이 존재하지 않아요.",
          buttonText: "혼자 달리기",
          buttonColor: .primary400,
          cancelAction: {

          },
          buttonAction: {
              
              startGroupRun = true
          })
        .popup(
          isPresented: $showGroupRunCancelAlter,
          title: "대기방을 삭제하시겠습니까?",
          subtitle: "\(nickname)님을 포함해 총 \(totalAggregateNum)명이 모였어요",
          buttonText: "삭제하기",
          buttonColor: .error,
          cancelAction: {

          },
          buttonAction: {
              dismiss()
          })
        .onAppear {
            PollingManager.shared.startPolling {
                self.pollingAction()
            }
        }
        .onDisappear {
            PollingManager.shared.stopPolling()
        }
        .navigationDestination(isPresented: $startGroupRun, destination:{
            RunningPage()
        })
    }
    
    func startRun() {
        let startRunningInfo = [
            "userId": UserDefaults.standard.string(forKey: "userId") ?? "",
            "runningId": runningSession.runningSessionInfo?.runningId ?? ""
        ]
        WebSocketService.sharedSocket.sendMessage(body: startRunningInfo, destination: "/app/runnings/start")
        startGroupRun = true
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
    CreateGroupRunPage(mapVM: .init(), runningSession: RunningSessionService(), passcode: "2312")
}
