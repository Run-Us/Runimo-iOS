//
//  StartGroupRunPage.swift
//  RunUs
//
//  Created by byeoungjik on 9/16/24.
//

import SwiftUI

struct StartGroupRunPage: View {
    @Environment(\.dismiss) var dismiss
    @State var showInputJoinCode = false
    @State var showJoinGroupRunPage = false
    @State var showCreateGroupRunPage = false
    @State var joinCode: String = ""
    @ObservedObject var runningSession: RunningSessionService
    @EnvironmentObject var mapVM: MapViewModel
    @EnvironmentObject var runVM: RunningViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    // Create Group Button
                    Image("login_view_2")
                        .padding(.vertical, 36)
                    
                    Text("친구와 함께 달려보세요!")
                        .font(.title4_semibold)
                        .foregroundStyle(.gray900)
                        
                    Text("그룹 달리기를 통해 친구와 같이 기록을 저장하세요")
                        .font(.body2_medium)
                        .foregroundStyle(.gray500)
                        .padding(8)
                    
                    Spacer()
                        
                    Divider()
                    // Join Group Button
                    Button(action: {
                        showInputJoinCode.toggle()
                    }, label: {
                        Text("이미 친구가 방을 만들었나요?")
                            .font(.caption_medium)
                            .underline()
                            .foregroundColor(.gray500)
                    })
                    .padding(.top, 8)
                    // create Group Button
                    Button(action: {
                        createGroup()
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                            Text("그룹 생성하기")
                                .font(.title5_bold)
                                .foregroundStyle(.white)
                        }
                    })
                    .frame(width: 361, height: 56)
                    .background(.primary400)
                    .cornerRadius(8)
                    .padding(8)
                    .navigationDestination(isPresented: $showCreateGroupRunPage, destination: {
                        CreateGroupRunPage(mapVM: mapVM, runningSession: runningSession, passcode: runningSession.latestSessionResponse?.payload.passcode ?? "0000")
                            .navigationBarBackButtonHidden()
                    })
                    
                }
                
            }
        }
        .navigationDestination(isPresented: $showJoinGroupRunPage, destination: {
            JoinGroupRunPage(RunningSession: runningSession)
        })

    }
    
    func createGroup() {
        runningSession.createRunningSession(currentLatitude: mapVM.userLocation.coordinate.latitude, currentLongitude: mapVM.userLocation.coordinate.longitude) { success, result in
            if success {
                UserDefaults.standard.set(result?.payload.runningKey, forKey: "runningId")
                WebSocketService.sharedSocket.connect(runningId: result?.payload.runningKey)
                showCreateGroupRunPage = true
            } else {
                print("createRunningSession || error")
            }
        }
    }
    func joinGroup() {
        
    }
        
}

#Preview {
    StartGroupRunPage(runningSession: RunningSessionService())
}
