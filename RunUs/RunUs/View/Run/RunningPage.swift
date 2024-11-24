//
//  RunningPage.swift
//  RunUs
//
//  Created by byeoungjik on 9/9/24.
//

import SwiftUI

struct RunningPage: View {
    @EnvironmentObject var mapVM: MapViewModel
    @EnvironmentObject var runVM: RunningViewModel
    @State private var showFinishPage: Bool = false
    @State private var showStopPopUp: Bool = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    ProgressBar(progress: $mapVM.motionManager.runningInfo.distance)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 25)
                    
                    Divider()
                    
                    // picker
                    SegmentedPicker(
                        selectedTab: $runVM.runningTab,
                        type: runVM.runningPickerTexts,
                        width: geometry.size.width
                    )
                    
                    // runningType으로 group 러닝일 때 RunningMapPage 재사용
                    TabView(selection: $runVM.runningTab) {
                        // 개요
                        RunningProgressPage(
                            motionManager: mapVM.motionManager
                        )
                        .tag(0)
                        
                        // 지도
                        RunningMapPage(
                            motionManager: mapVM.motionManager,
                            showStopAlert: $showStopPopUp,
                            showFinishPage: $showFinishPage
                        )
                        .tag(1)
                        
                        // 그룹원
                        if runVM.runningType == .group {
                            RunningMapPage(
                                motionManager: mapVM.motionManager,
                                showStopAlert: $showStopPopUp,
                                showFinishPage: $showFinishPage
                            )
                            .tag(2)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    
                    // custom page dots
                    HStack {
                        ForEach(runVM.runningPickerTexts.indices, id: \.self) { index in
                            Circle()
                                .frame(width: 8, height: 8)
                                .foregroundStyle(index == runVM.runningTab ? .primary500 : .primary200)
                        }
                    }
                }
            }
            .popup(
                isPresented: $showStopPopUp,
                title: "러닝을 종료하시겠어요?",
                subtitle: "시간: \(mapVM.motionManager.runningInfo.runningTime ?? "0:00") / 거리: \(String(format: "%.2fkm", mapVM.motionManager.runningInfo.distance ?? 0.0))",
                buttonText: "끝내기",
                buttonColor: .primary400,
                cancelAction: {
                    // 취소 : 다시 위치 측정 시작
                    mapVM.startUpdatingLocation()
                },
                buttonAction: {
                    // 끝내기
                    mapVM.stopRunning(runningType: runVM.runningType)
                    runVM.initRunVM()
                    showFinishPage = true
            })
            .navigationBarBackButtonHidden()
            .onAppear {
                
                // 권한이 모두 허용됐을 경우에만 측정 시작
                mapVM.motionManager.checkPedometerAuthorization { isSuccess in
                    if isSuccess {
                        mapVM.motionManager.runningInfo = RunningInfo(startDate: Date())
                        mapVM.startUpdatingLocation()
                    }
                }
                
            }
        }
    }
}

#Preview {
    RunningPage(mapVM: .init())
}
