//
//  MyPageViewModel.swift
//  RunUs
//
//  Created by 가은 on 10/31/24.
//

import Foundation
import SwiftUI

enum RecordType {
    case weekly, monthly, yearly
}

class MyPageViewModel: ObservableObject {
    @ObservedObject var dateManager: DateManager = DateManager()
    @Published var selectedTab: Int = 0
    @Published var showDateSheet: Bool = false
    @Published var user: MyPage
    
    init() {
        user = MyPage(profileImage: nil, nickname: "", totalDistance: 0, recentRunningDate: nil, runningRecords: [])
    }
    
    var recordType: RecordType {
        switch (selectedTab) {
        case 0: return .weekly
        case 1: return .monthly
        default: return .yearly
        }
    }
}

// API
extension MyPageViewModel {
    // 누적 거리
    func getTotalDistance() -> String {
        return String(format: "%.2fkm", user.totalDistance/1000)
    }
    
    // 최근 러닝
    func lastRunning() -> String {
        let day = dateManager.subDate(date: user.recentRunningDate)
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
            return Array(1...31).map{String($0)}
        case .yearly:
            return Array(1...12).map{String($0)}
        }
    }
    
    // 막대 그래프 cornerRadius
    var barGraphCornerRadius: CGFloat {
        switch (recordType) {
        case .weekly: return 12
        case .monthly: return 4
        case .yearly: return 8
        }
    }
    
    // 막대 그래프 사이 spacing
    var graphSpacing: CGFloat {
        switch (recordType) {
        case .weekly: return 10
        case .monthly: return 4
        case .yearly: return 6
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
