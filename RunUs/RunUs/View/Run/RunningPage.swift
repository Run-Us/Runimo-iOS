//
//  RunningPage.swift
//  RunUs
//
//  Created by byeoungjik on 9/9/24.
//

import SwiftUI

enum RunningType {
    case alone
    case group
}

struct RunningPage: View {
    let runningType: RunningType
    @StateObject var mapVM: MapViewModel
    @State private var selectedTab: Int = 0
    @State private var showFinishPage: Bool = false
    @State private var showStopPopUp: Bool = false
    
    var pickerList: [String] {
        switch (runningType) {
        case .alone:  return ["개요", "지도"]
        case .group:  return ["개요", "지도", "그룹원"]
        }
    }

    
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
                        selectedTab: $selectedTab,
                        type: pickerList,
                        width: geometry.size.width
                    )
                    
                    // runningType으로 group 러닝일 때 RunningMapPage 재사용
                    TabView(selection: $selectedTab) {
                        // 개요
                        RunningProgressPage(
                            mapVM: mapVM,
                            motionManager: mapVM.motionManager,
                            selectedTab: $selectedTab
                        )
                        .tag(0)
                        
                        // 지도
                        RunningMapPage(
                            mapVM: mapVM,
                            motionManager: mapVM.motionManager,
                            runningType: .alone,
                            showStopAlert: $showStopPopUp,
                            selectedTab: $selectedTab,
                            showFinishPage: $showFinishPage
                        )
                        .tag(1)
                        
                        // 그룹원
                        RunningMapPage(
                            mapVM: mapVM,
                            motionManager: mapVM.motionManager,
                            runningType: .group,
                            showStopAlert: $showStopPopUp,
                            selectedTab: $selectedTab,
                            showFinishPage: $showFinishPage
                        )
                        .tag(2)
                    }
                    .tabViewStyle(PageTabViewStyle())
                    
                    // custom page dots
                    HStack {
                        if let picker = pickerText[runningType] {
                            ForEach(picker.indices, id: \.self) { index in
                                Circle()
                                    .frame(width: 8, height: 8)
                                    .foregroundStyle(index == selectedTab ? .primary500 : .primary200)
                            }
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
                    mapVM.stopUpdatingLocation()
                    WebSocketService.sharedSocket.sendMessageAggregate()
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
    RunningPage(runningType: .group, mapVM: .init())
}
