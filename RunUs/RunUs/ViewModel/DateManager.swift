//
//  DateManager.swift
//  RunUs
//
//  Created by 가은 on 11/4/24.
//

import Foundation

class DateManager: ObservableObject {
    var calendar = Calendar.current
    var date = Date()
    var formatter = DateFormatter()
    
    init() {
        formatter.locale = Locale(identifier: "ko_kr")
        calendar.firstWeekday = 2
    }
}

// MARK: Formatting
extension DateManager {
    // 주간, 월간, 연간 별 날짜 string으로 반환
    func getDateString(date: Date, type: RecordType) -> String {
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
    
    // yyyy-MM-dd 형식 날짜 string
    func getDateForAPI(date: Date) -> String {
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    // 날짜 차이 계산
    func subDate(date: Date?) -> Int {
        if let date = date {
            let offset = Calendar.current.dateComponents([.day], from: date, to: Date())
            return offset.day ?? -1
        }
        return -1
    }
}

// MARK: RecordCard
extension DateManager {
    // RecordCard 기간용
    func getRecordDateRange(type: RecordType) -> String {
        switch (type) {
        case .weekly: getWeekDateRange()
        case .monthly, .yearly: getDateString(date: date, type: type)
        }
    }
    
    // 주간 기간 string 얻기
    private func getWeekDateRange() -> String {
        if isThisWeek(date) { return "이번주" }
        if let week = calendar.dateInterval(of: .weekOfYear, for: date) {
            let startOfWeek = week.start
            let endOfWeek = calendar.date(byAdding: .day, value: -1, to: week.end)!
            
            return getDateString(date: startOfWeek, type: .weekly) + " - " + getDateString(date: endOfWeek, type: .weekly)
        }
        return ""
    }
    
    // 날짜가 이번주인지 확인
    private func isThisWeek(_ date: Date) -> Bool {
        return calendar.isDate(date, equalTo: Date(), toGranularity: .weekOfYear)
    }
}
