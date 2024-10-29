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
    let pickerText: Dictionary<RunningType,[String]> = [
        .alone: ["개요", "지도"],
        .group: ["개요", "지도", "그룹원"]
    ]
    
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
                        type: pickerText[runningType] ?? [],
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
                            selectedTab: $selectedTab,
                            showFinishPage: $showFinishPage
                        )
                        .tag(1)
                        
                        // 그룹원
                        RunningMapPage(
                            mapVM: mapVM,
                            motionManager: mapVM.motionManager,
                            runningType: .group,
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
