//
//  RunningViewModel.swift
//  RunUs
//
//  Created by 가은 on 11/6/24.
//

import Foundation

enum RunningType: String {
    case alone = "single"
    case group = "multi"
}

class RunningViewModel: ObservableObject {
    @Published var selectedRunningTab: Int = 0  // alone or group
    @Published var runningTab: Int = 0  // 러닝 진행 중 picker tab
    
    func initRunVM() {
        runningTab = 0
    }
    
    // 현재 선택된 러닝 타입
    var runningType: RunningType {
        switch (selectedRunningTab) {
        case 0: return .alone
        default: return .group
        }
    }
    
    var runningPickerTexts: [String] {
        switch (runningType) {
        case .alone:  return ["개요", "지도"]
        case .group:  return ["개요", "지도", "그룹원"]
        }
    }
}
