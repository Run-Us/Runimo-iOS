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
    @Published var graphDisplay: (count: Int, distance: String, time: String, maxYLength: Double, distanceList: [Double]) = (0, "0.00km", "0m 0s", 9.0, Array(repeating: 8.0, count: 30))
    
    init() {
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

// API
extension MyPageViewModel {
    // 누적 거리
    func getTotalDistance() -> String {
        return String(format: "%.2fkm", user.total_distance_in_meters/1000)
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
            MyPageService.shared.getWeeklyRunningRecords(startDate: getDateString(date: start ?? Date()), endDate: getDateString(date: end ?? Date())) { result in
                
            }
        } else {
            let (year, month) = dateManager.getYearMonth(date: start ?? Date())
            MyPageService.shared.getMonthlyRunningRecords(year: year, month: month) { data in
                
            }
        }
        // TODO: 서버 정상화 시 주석 해제
//        getGraphData()
    }
    
    // 통계 (화면 표시용)
    func getGraphData() {
        let distance = Double(graph.total_distance)/1000
        let minute = graph.total_time/60
        let second = graph.total_time%60
        let maxYLength = ceil(distance)
        
        graphDisplay = (
            count: graph.total_count,
            distance: String(format: "%.2fkm", distance),
            time: "\(minute)m \(second)s",
            maxYLength: maxYLength,
            distanceList: graph.distance_list.map{ Double($0)/1000 }
        )
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
            return Array(1...graphDisplay.distanceList.count).map{String($0)}
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
