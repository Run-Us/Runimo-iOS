//
//  DateManager.swift
//  RunUs
//
//  Created by 가은 on 11/4/24.
//

import Foundation

class DateManager: ObservableObject {
    var date = Date()
    var formatter = DateFormatter()
    
    init() {
        formatter.locale = Locale(identifier: "ko_kr")
    }
    
    // 주간, 월간, 연간 별 날짜 string으로 반환
    func getDateString(type: RecordType) -> String {
        switch (type) {
        case .weekly:
            formatter.dateFormat = "MM월 dd일"
        case .monthly:
            formatter.dateFormat = "yyyy년 MM월"
        case .yearly:
            formatter.dateFormat = "yyyy년"
        }
        return formatter.string(from: date)
    }
}
