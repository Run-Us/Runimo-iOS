//
//  RunningProgressPage.swift
//  RunUs
//
//  Created by 가은 on 9/11/24.
//

import SwiftUI

struct RunningProgressPage: View {
    @StateObject var mapVM: MapViewModel
    @StateObject var motionManager: MotionManager
    
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(spacing: 50) {
            Spacer()
            VStack(spacing: 15) {
                Text(motionManager.runningInfo.runningTime ?? "00:00")
                    .font(.title2_bold)
                    .foregroundStyle(.gray900)
                Text("시간")
            }
            
            VStack(spacing: 15) {
                if let distance = motionManager.runningInfo.distance {
                    Text("\(distance, specifier: "%.2f")")
                        .font(.title1_bold)
                        .foregroundStyle(.gray900)
                } else {
                    Text("0.00")
                        .font(.title1_bold)
                        .foregroundStyle(.gray900)
                }
                Text("거리 (km)")
            }
            
            VStack(spacing: 15) {
                Text(motionManager.runningInfo.averagePace ?? "-’--”")
                    .font(.title2_bold)
                    .foregroundStyle(.gray900)
                Text("평균 페이스")
            }
            
            Button(action: {
                selectedTab = 1
                mapVM.stopUpdatingLocation()
            }, label: {
                Image("run_pause")
            })
            .padding(.top, 20)
            Spacer()
        }
        .font(.body1_medium)
        .foregroundStyle(.gray400)
    }
}

#Preview {
    RunningProgressPage(mapVM: MapViewModel(), motionManager: MotionManager() ,selectedTab: .constant(0))
}
