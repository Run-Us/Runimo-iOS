//
//  RunningMapPage.swift
//  RunUs
//
//  Created by 가은 on 9/10/24.
//

import SwiftUI

struct RunningMapPage: View {
    @EnvironmentObject var mapVM: MapViewModel
    @EnvironmentObject var runVM: RunningViewModel
    @StateObject var motionManager: MotionManager
    @Binding var showStopAlert: Bool
    @Binding var showFinishPage: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 50) {
                
                // 상단 지도
                ZStack(alignment: .bottom) {
                    MapPage()
                        .frame(height: geometry.size.width)
                    
                    // 일시정지 버튼
                    if mapVM.isRunning {
                        Button(action: {
                            mapVM.stopUpdatingLocation()
                            runVM.runningTab = 1
                        }, label: {
                            Image("run_pause")
                                .shadow(radius: 2, x: 0, y: 4)
                        })
                        .padding()
                    }
                    // 계속하기&끝내기 버튼
                    else {
                        HStack(spacing: 40) {
                            Button {
                                showStopAlert = true
                                mapVM.stopUpdatingLocation()
                            } label: {
                                Image("run_stop")
                                    .shadow(radius: 2, x: 0, y: 4)
                            }
                            
                            Button {
                                mapVM.startUpdatingLocation()
                            } label: {
                                Image("run_start")
                                    .shadow(radius: 2, x: 0, y: 4)
                            }
                        }
                        .padding()
                    }
                }
                
                // 하단 러닝 정보
                switch (runVM.runningType) {
                case .alone: mapTabInfo(width: geometry.size.width/2)
                case .group: RunningParticipants()
                }
            }
            .navigationDestination(isPresented: $showFinishPage) {
                FinishRunningPage(mapVM: mapVM)
            }
        }
    }
    
    @ViewBuilder
    func mapTabInfo(width: CGFloat) -> some View {
        VStack(spacing: 35) {
            HStack {
                Spacer()
                VStack(spacing: 10) {
                    Text(motionManager.runningInfo.runningTime ?? "00:00")
                        .font(.title3_bold)
                        .foregroundStyle(.primaryGray)
                    Text("시간")
                }
                Spacer()
                VStack(spacing: 10) {
                    Text(motionManager.runningInfo.averagePace ?? "-’--”")
                        .font(.title3_bold)
                        .foregroundStyle(.primaryGray)
                    Text("평균 페이스")
                }
                Spacer()
            }
            VStack(spacing: 10) {
                if let distance = motionManager.runningInfo.distance {
                    Text("\(distance, specifier: "%.2f")km")
                        .font(.title2_bold)
                        .foregroundStyle(.primaryGray)
                } else {
                    Text("0.00")
                        .font(.title2_bold)
                        .foregroundStyle(.primaryGray)
                }
                Text("거리 (km)")
            }
        }
        .font(.body1_medium)
        .foregroundStyle(.gray400)
    }
}

#Preview {
    RunningMapPage(motionManager: MotionManager(), showStopAlert: .constant(false), showFinishPage: .constant(false))
}
