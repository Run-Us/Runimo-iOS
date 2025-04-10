//
//  DateManager.swift
//  RunUs
//
//  Created by 가은 on 11/4/24.
//

import Foundation

class DateManager: ObservableObject {
    static let shared = DateManager()
    var calendar = Calendar.current
    var date = Date()
    var formatter = DateFormatter()
    
    private init() {
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
        }
        return formatter.string(from: date)
    }
    
    // yyyy-MM-dd 형식 날짜 string
    func getDateForAPI(date: Date) -> String {
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    // 날짜 string
    func getDay(date: Date) -> String {
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    // 요일 string
    func getWeekday(date: Date) -> String {
        formatter.dateFormat = "E"
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

// MARK: SessionTab week
extension DateManager {
    // 오늘 ~ +7일 정보
    func getDayTodayTo7days() -> [(day: String, weekday: String)] {
        var week: [(String, String)] = []
        for i in 0..<8 {
            let date: Date = calendar.date(byAdding: .day, value: i, to: Date()) ?? Date()
            week.append((getDay(date: date), getWeekday(date: date)))
        }
        return week
    }
}

// MARK: RecordCard
extension DateManager {
    // RecordCard 기간용
    func getRecordDateRange(type: RecordType) -> String {
        switch (type) {
        case .weekly: getWeekDateRange()
        case .monthly: getDateString(date: date, type: type)
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
    
    func getDateRange(type: RecordType) -> (start: Date?, end: Date?) {
        if let range = calendar.dateInterval(of: type.calendarComponent, for: date) {
            let start = range.start
            let end = calendar.date(byAdding: .day, value: -1, to: range.end)!
            
            return (start, end)
        }
        return (nil, nil)
    }
}
