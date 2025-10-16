//
//  RunningViewModel.swift
//  RunUs
//
//  Created by 가은 on 11/6/24.
//

import Foundation
import Combine
import Alamofire

enum RunningType: String {
    case alone = "single"
    case group = "multi"
}

class RunningViewModel: ObservableObject {
    @Published var selectedRunningTab: Int = 0  // single or group
    @Published var runningTab: Int = 0  // 러닝 진행 중 picker tab
    @Published var stopRunPopUpText: (title: String, subtitle: String, buttonText: String, cancelText: String) = ("", "", "", "")
    
    /// 완료한 러닝 ID
    @Published var completeRunningID: String = ""
    @Published var rewardData: (egg: String, point: Int) = ("", 0)
    /// 러닝 상세 데이터
    @Published var runningDetail: RunningPostResponse?
    
    
    private var cancellables: Set<AnyCancellable> = []
    
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
                "님을 포함해 총 명이 모였어요",
                "시작하기"
            )
        }
    }
    
    func completeRunPopUpMessage(runningInfo: RunningInfo) {
        if runningInfo.distance ?? 0 >= 1.0 {
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

// MARK: - API
extension RunningViewModel {
    /// 러닝 완료: 저장 -> 보상
    func completeRunning(result: RunningResult, completion: @escaping () -> Void) {
        saveRunningRecords(result: result)
            .flatMap { [weak self] response -> AnyPublisher<RewardResponse, AFError> in
                guard let self = self else {
                    return Fail(error: AFError.explicitlyCancelled)
                        .eraseToAnyPublisher()
                }
                self.completeRunningID = response.saved_id
                
                return self.getRunningReward(runningID: response.saved_id)
            }
            .sink(receiveCompletion: handleCompletion) { [weak self] response in
                self?.rewardData = (
                    response.is_rewarded ? response.egg_type : "",
                    response.love_point_amount
                )
                
                completion()
            }
            .store(in: &cancellables)
    }
    
    /// 러닝 기록 저장 API 호출
    func saveRunningRecords(result: RunningResult) -> AnyPublisher<SaveRunningResponse, AFError> {
        return RunningService.shared.saveRunningRecords(running: result)
    }
    
    /// 러닝 완료 보상 얻기 API 호출
    func getRunningReward(runningID: String) -> AnyPublisher<RewardResponse, AFError> {
        return RunningService.shared.getRunningReward(runningId: runningID)
    }
    
    /// 러닝 상세 조회 API 호출
    func getRunningDetail(runningId: String) {
        RunningService.shared.getRunningDetail(runningId: runningId)
            .sink(
                receiveCompletion: handleCompletion,
                receiveValue: { [weak self] result in
                    self?.runningDetail = result
            })
            .store(in: &cancellables)
    }
    
    /// 러닝 기록 수정
    func editRunningRecords(runningId: String, title: String, description: String, imgURL: String, completion: @escaping () -> Void) {
        RunningService.shared.patchRunningRecords(
            runningId: runningId,
            title: title,
            description: description,
            imgURL: imgURL
        )
        .sink(receiveCompletion: handleCompletion) { [weak self] statusCode in
            if statusCode == 200 {
                self?.completeRunningID = ""
                completion()
            }
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    /// Comine 완료 이벤트 처리 메서드
    private func handleCompletion(_ completion: Subscribers.Completion<AFError>) {
        if case .failure(let error) = completion {
            print("❌ Error: \(error)")
        }
    }
}
