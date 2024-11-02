//
//  MyPageViewModel.swift
//  RunUs
//
//  Created by 가은 on 10/31/24.
//

import Foundation

enum RecordType {
    case weekly, monthly, yearly
}

class MyPageViewModel: ObservableObject {
    @Published var selectedTab: Int = 0
    
    var recordType: RecordType {
        switch (selectedTab) {
        case 0: return .weekly
        case 1: return .monthly
        default: return .yearly
        }
    }
    
    var periodText: String {
        switch (recordType) {
        case .weekly: return "이번 주"
        case .monthly: return "2024년 10월"
        case .yearly: return "2024년"
        }
    }
    
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
