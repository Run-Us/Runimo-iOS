//
//  RunningPage.swift
//  RunUs
//
//  Created by byeoungjik on 9/9/24.
//

import SwiftUI

struct RunningPage: View {
    @EnvironmentObject var navigation: NavigationManager
    @EnvironmentObject var sharedData: SharedData
    @EnvironmentObject var mapVM: MapViewModel
    @EnvironmentObject var runVM: RunningViewModel
    @State private var showStopPopUp: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.secondaryBG
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    ProgressBar(progress: mapVM.motionManager.runningInfo.distance)
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
                            showStopAlert: $showStopPopUp
                        )
                        .tag(1)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
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
        }
        .popup(
            isPresented: $showStopPopUp,
            title: runVM.stopRunPopUpText.title,
            subtitle: runVM.stopRunPopUpText.subtitle,
            buttonText: runVM.stopRunPopUpText.buttonText,
            cancelButtonText: runVM.stopRunPopUpText.cancelText,
            buttonColor: .primary400,
            cancelAction: {
                // 삭제
                if mapVM.motionManager.runningInfo.distance ?? 0 < 1.0 {
                    mapVM.stopRunning(runningType: runVM.runningType)
                    runVM.initRunVM()
                    navigation.goToRootPage()
                }
            },
            buttonAction: {
                // 1km 이상 달려야 저장
                if mapVM.motionManager.runningInfo.distance ?? 0 >= 1.0 {
                    // 끝내기
                    mapVM.stopRunning(runningType: runVM.runningType)
                    runVM.initRunVM()
                    saveRunningAPI()
                } else {
                    // 계속하기
                    mapVM.startUpdatingLocation()
                }
        })
        .navigationBarBackButtonHidden()
        .onAppear {
            
            // 권한이 모두 허용됐을 경우에만 측정 시작
            mapVM.motionManager.checkPedometerAuthorization { isSuccess in
                if isSuccess {
                    mapVM.motionManager.runningInfo = RunningInfo(startDate: Date())
                    mapVM.motionManager.runningResult = RunningResult(started_at: Date())
                    mapVM.startUpdatingLocation()
                }
            }
            
        }
    }
    
    // 러닝 기록 저장
    private func saveRunningAPI() {
        RunningSessionService.shared.saveRunningRecords(running: mapVM.motionManager.runningResult) { isSuccess, runningId in
            if isSuccess {
                sharedData.completeRunningID = runningId
                RunningSessionService.shared.getRunningReward(runningId: runningId) { data in
                    if data.is_rewarded {
                        sharedData.rewardData = (data.egg_type, data.love_point_amount)
                        navigation.path.append(RunningRewardPage.id)
                    } else {
                        navigation.path.append(FinishRunningPage.id)
                    }
                }
            }
        }
    }
}

#Preview {
    RunningPage()
}
