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
    @Published var selectedRunningTab: Int = 0  // single or group
    @Published var runningTab: Int = 0  // 러닝 진행 중 picker tab
    private let nickname = UserDefaults.standard.string(forKey: "nickname") ?? ""
    @Published var totalAggregateNum: Int = 0
    @Published var stopRunPopUpText: (title: String, subtitle: String, buttonText: String, cancelText: String) = ("", "", "", "")
    
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
    
    // 혼자달리기로 설정
    func setRunningModeSingle() {
        selectedRunningTab = 0
    }
    
    // 그룹달리기로 설정
    func setRunningModeGroup() {
        selectedRunningTab = 1
    }
    
    func getStartRunPopUpMessage() -> (title: String, subtitle: String, buttonText: String) {
        switch runningType {
        case .alone:
            return (
                "혼자서 달리시나요?",
                "아직 입장한 그룹원이 존재하지 않아요.",
                "혼자 달리기"
            )
        case .group:
            return (
                "그룹 달리기를 시작할까요?",
                "\(nickname)님을 포함해 총 \(totalAggregateNum)명이 모였어요",
                "시작하기"
            )
        }
    }
    
    func completeRunPopUpMessage(runningInfo: RunningInfo) {
        if runningInfo.distance ?? 0 >= 1000 {
            stopRunPopUpText = (
                "러닝을 종료하시겠어요?",
                "시간: \(runningInfo.runningTime ?? "0:00") / 거리: \(String(format: "%.2fkm", runningInfo.distance ?? 0.0))",
                "끝내기",
                "취소"
            )
        } else {
            stopRunPopUpText = (
                "러닝 기록이 충분하지 않아요",
                "지금 러닝을 끝내면 활동이 삭제돼요.",
                "계속하기",
                "삭제하기"
            )
        }
    }
}
