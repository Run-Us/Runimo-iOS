//
//  RunningProgressPage.swift
//  RunUs
//
//  Created by 가은 on 9/11/24.
//

import SwiftUI

struct RunningProgressPage: View {
    @EnvironmentObject var mapVM: MapViewModel
    @EnvironmentObject var runVM: RunningViewModel
    @StateObject var motionManager: MotionManager
    
    var body: some View {
        VStack(spacing: 50) {
            Spacer()
            VStack(spacing: 15) {
                Text(motionManager.runningInfo.runningTime ?? "00:00")
                    .font(.title2_bold)
                    .foregroundStyle(.primaryGray)
                Text("시간")
            }
            
            VStack(spacing: 15) {
                if let distance = motionManager.runningInfo.distance {
                    Text("\(distance, specifier: "%.2f")")
                        .font(.title1_bold)
                        .foregroundStyle(.primaryGray)
                } else {
                    Text("0.00")
                        .font(.title1_bold)
                        .foregroundStyle(.primaryGray)
                }
                Text("거리 (km)")
            }
            
            VStack(spacing: 15) {
                Text(motionManager.runningInfo.averagePace ?? "-’--”")
                    .font(.title2_bold)
                    .foregroundStyle(.primaryGray)
                Text("평균 페이스")
            }
            
            if mapVM.isRunning {
                Button(action: {
                    CommonExtension.triggerHaptic()
                    runVM.runningTab = 1
                    mapVM.stopUpdatingLocation()
                }, label: {
                    Image("run_pause")
                        .frame(width: 80, height: 80)
                })
                .padding(.top, 20)
            } else {
                Button {
                    CommonExtension.triggerHaptic()
                    mapVM.startUpdatingLocation()
                } label: {
                    Image("run_start")
                        .frame(width: 80, height: 80)
                }
                .padding(.top, 20)
            }
            
            Spacer()
        }
        .font(.body1_medium)
        .foregroundStyle(.gray400)
    }
}

#Preview {
    RunningProgressPage(motionManager: MotionManager())
}
