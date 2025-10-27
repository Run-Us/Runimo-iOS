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

@MainActor
class RunningViewModel: ObservableObject {
    @Published var selectedRunningTab: Int = 0  // single or group
    @Published var runningTab: Int = 0  // 러닝 진행 중 picker tab
    @Published var stopRunPopUpText: (title: String, subtitle: String, buttonText: String, cancelText: String) = ("", "", "", "")

    /// 완료한 러닝 ID
    @Published var completeRunningID: String = ""
    @Published var rewardData: (egg: String, point: Int) = ("", 0)
    /// 러닝 상세 데이터
    @Published var runningDetail: RunningPostResponse?
    /// 이번 달 달린 횟수
    @Published var totalRunningCount: Int = 0

    // MARK: - 러닝 기록 리스트 관리
    /// 러닝 기록 리스트
    @Published var runningList: [RunningRecord] = []
    /// 현재 페이지
    @Published var currentPage: Int = 0
    /// 전체 페이지 수
    @Published var totalPages: Int = 1
    /// 로딩상태
    @Published var isLoadingRecords: Bool = false

    private var cancellables: Set<AnyCancellable> = []

    // 의존성 주입
    private let runningService: RunningServiceProtocol

    init(runningService: RunningServiceProtocol = RunningService.shared) {
        self.runningService = runningService
    }
    
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
        Task {
            do {
                // 1. 러닝 기록 저장
                let savedId = try await saveRunningRecords(result: result)

                // 2. 보상 받기
                try await getRunningReward(runningID: savedId)

                completion()
            } catch {
                print("❌ Error: \(error)")
            }
        }
    }

    /// 러닝 기록 저장 API 호출
    func saveRunningRecords(result: RunningResult) async throws -> String {
        let response = try await runningService.saveRunningRecords(running: result)
        self.completeRunningID = response.saved_id
        return response.saved_id
    }

    /// 러닝 완료 보상 얻기 API 호출
    func getRunningReward(runningID: String) async throws {
        let response = try await runningService.getRunningReward(runningId: runningID)
        self.rewardData = (
            response.is_rewarded ? response.egg_type : "",
            response.love_point_amount
        )
    }
    
    /// 러닝 상세 조회 API 호출
    func getRunningDetail(runningId: String) {
        Task {
            do {
                let data = try await runningService.getRunningDetail(runningId: runningId)
                
                self.runningDetail = data
            } catch {
                print("❌ Error: \(error)")
            }
        }
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
    
    /// 러닝 기록 리스트 초기화
    func resetRunningRecords() {
        runningList = []
        currentPage = 0
        totalPages = 1
    }

    /// 러닝 기록 조회 (페이지네이션)
    func getMyRunningRecords(page: Int, selectedDate: Date) {
        // 이미 로딩 중이거나 마지막 페이지를 넘어서면 요청하지 않음
        guard !isLoadingRecords, page < totalPages else { return }

        isLoadingRecords = true
        
        Task {
            do {
                let response = try await runningService.getMyRunningRecords(page: page, selectedDate: selectedDate)
                
                self.totalRunningCount = response.pagination.total_items
                self.totalPages = response.pagination.total_pages
                self.currentPage = response.pagination.current_page
                
                // 기존 리스트에 새 데이터 추가
                self.runningList += response.items
                
                // 로딩 끝
                self.isLoadingRecords = false
            } catch {
                self.isLoadingRecords = false
                print("❌ Error: \(error)")
            }
        }
    }
    
    // MARK: - Private Methods
    /// Comine 완료 이벤트 처리 메서드
    private func handleCompletion(_ completion: Subscribers.Completion<AFError>) {
        if case .failure(let error) = completion {
            print("❌ Error: \(error)")
        }
    }
}
