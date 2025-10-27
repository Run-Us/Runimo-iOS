//
//  MyPageViewModel.swift
//  RunUs
//
//  Created by 가은 on 10/31/24.
//

import Foundation
import SwiftUI

enum RecordType: String {
    case weekly, monthly

    var calendarComponent: Calendar.Component {
        switch self {
        case .weekly: return .weekOfYear
        case .monthly: return .month
        }
    }
}

@MainActor
class MyPageViewModel: ObservableObject {
    let dateManager = DateManager.shared
    @Published var selectedTab: Int = 0 {
        didSet {
            getGraphAPI()
        }
    }

    @Published var showDateSheet: Bool = false
    @Published var user: MyPage
    @Published var graph: RunningGraph
    @Published var graphDisplay: (count: Int, distance: String, time: String, maxYLength: Double) = (0, "0.00km", "0m 0s", 6.0)
    @Published var dailyStats: [DailyStats] = []
    @Published var weeklyGraphList: [Double] = Array(repeating: 0.0, count: 7)
    @Published var monthlyGraphList: [Double] = Array(repeating: 0.0, count: 30)

    // 의존성 주입
    private let myPageService: MyPageServiceProtocol

    init(myPageService: MyPageServiceProtocol = MyPageService.shared) {
        self.myPageService = myPageService
        user = MyPage(profile_image_url: nil, nickname: "", total_distance_in_meters: 0, latest_run_date_before: 0, latest_running_record_nullable: nil)
        graph = RunningGraph(total_count: 0, total_distance: 0, total_time: 0, distance_list: [])
        getGraphAPI()
    }
    
    var recordType: RecordType {
        switch (selectedTab) {
        case 0: return .weekly
        default: return .monthly
        }
    }
}

// MARK: - API
extension MyPageViewModel {
    /// 마이페이지 조회 API 호출
    func getMyPage() {
        Task {
            do {
                let data = try await myPageService.getMyPage()
                self.user = data
                if let profile = data.profile_image_url {
                    UserDefaults.standard.set(profile, forKey: "profileURL")
                }
            } catch {
                print("❌ Error: \(error)")
            }
        }
    }
    
    /// 주간 통계 API 호출
    private func getWeeklyRecords(start: Date, end: Date) {
        Task {
            do {
                let data = try await myPageService.getWeeklyRunningRecords(
                    startDate: getDateString(date: start),
                    endDate: getDateString(date: end)
                )
                
                let simpleStat = data.simple_stat
                self.graph = RunningGraph(
                    total_count: simpleStat.total_running_count,
                    total_distance: simpleStat.total_distance_in_meters,
                    total_time: simpleStat.total_time_in_seconds,
                    distance_list: []
                )
                
                self.dailyStats = data.daily_stats
                self.setGraphData(startDate: start)
            } catch {
                print("❌ Error: \(error)")
            }
        }
    }
    
    /// 월간 통계 API 호출
    private func getYearlyRecords(year: Int, month: Int, startDate: Date) {
        Task {
            do {
                let data = try await myPageService.getMonthlyRunningRecords(year: year, month: month)
                
                let simpleStat = data.simple_stat
                self.graph = RunningGraph(
                    total_count: simpleStat.total_running_count,
                    total_distance: simpleStat.total_distance_in_meters,
                    total_time: simpleStat.total_time_in_seconds,
                    distance_list: []
                )
                
                self.dailyStats = data.daily_stats
                self.setGraphData(startDate: startDate)
            } catch {
                print("❌ Error: \(error)")
            }
        }
    }
}

extension MyPageViewModel {
    // 누적 거리
    func getTotalDistance() -> String {
        return String(format: "%.2fkm", Double(user.total_distance_in_meters)/1000)
    }
    
    // 최근 러닝
    func lastRunning() -> String {
        let day = user.latest_run_date_before
        if day == 0 {
            return "오늘"
        } else if day == 1 {
            return "하루 전"
        } else if day > 1 {
            return "\(day)일 전"
        } else {
            return "없음"
        }
    }
    
    // yyyy-MM-dd 형식 날짜 String
    func getDateString(date: Date) -> String {
        return dateManager.getDateForAPI(date: date)
    }
    
    // 마이페이지 통계 API 호출
    func getGraphAPI() {
        let (start, end) = dateManager.getDateRange(type: recordType)
        guard start != nil, end != nil else { return }
        
        if recordType == .weekly {
            getWeeklyRecords(
                start: start ?? Date(),
                end: end ?? Date()
            )
        } else {
            let (year, month) = dateManager.getYearMonth(date: start ?? Date())
            getYearlyRecords(
                year: year,
                month: month,
                startDate: start ?? Date()
            )
        }
    }
    
    func setGraphData(startDate: Date) {
        graph.distance_list = Array(repeating: 0, count: dateManager.getCurrentMonthDayCount())
        
        for stat in dailyStats {
            if let date = dateManager.convertStringToDate(dateString: stat.date) {
                let index = dateManager.getDifferenceDayCount(from: startDate, to: date)
                graph.distance_list[index] += stat.distance_in_meters
            }
        }
        
        getGraphData()
    }
    
    // 통계 (화면 표시용)
    func getGraphData() {
        let distance = Double(graph.total_distance)/1000
        let maxYLength = ceil(Double(graph.distance_list.max() ?? 0)/1000)
        
        graphDisplay = (
            count: graph.total_count,
            distance: String(format: "%.2fkm", distance),
            time: convertTimeToString(seconds: graph.total_time),
            maxYLength: maxYLength > 0 ? maxYLength : 6.0
        )
        
        if recordType == .weekly {
            weeklyGraphList = graph.distance_list.map{ Double($0)/1000 }
        } else {
            monthlyGraphList = graph.distance_list.map{ Double($0)/1000 }
        }
    }
    
    private func convertTimeToString(seconds: Int) -> String {
        if seconds >= 60 * 60 {     // 1시간 이상
            return "\(seconds/3600)h \((seconds%3600)/60)m"
        }
        return "\(seconds/60)m \(seconds%60)s"
    }
}

// MARK: RecordCard
extension MyPageViewModel {
    var periodText: String {
        get {
            dateManager.getRecordDateRange(type: recordType)
        }
    }
}

// MARK: Graph
extension MyPageViewModel {
    var xData: [String] {
        switch (recordType) {
        case .weekly:
            return ["월","화","수","목","금","토","일"]
        case .monthly:
            return Array(1...monthlyGraphList.count).map{String($0)}
        }
    }
    
    // 막대 그래프 cornerRadius
    var barGraphCornerRadius: CGFloat {
        switch (recordType) {
        case .weekly: return 12
        case .monthly: return 4
        }
    }
    
    // 막대 그래프 사이 spacing
    var graphSpacing: CGFloat {
        switch (recordType) {
        case .weekly: return 10
        case .monthly: return 4
        }
    }
    
    // 그래프 날짜 데이터 값 필터
    func checkMonthlyData(data: String) -> Bool {
        if ["6","13","20","27"].contains(data) {
            return true
        }
        return false
    }
}
