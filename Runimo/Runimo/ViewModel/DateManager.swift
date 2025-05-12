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
    
    func getMonth(date: Date) -> String {
        formatter.dateFormat = "M"
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
    
    func getString(date: Date?) -> String {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = date {
            return formatter.string(from: date)
        }
        return ""
    }
    
    func convertDateString(dateString: String) -> Date? {
        // input format
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = formatter.date(from: dateString) {
            return date
        }
        return nil
    }
    
    func convertStringToDate(dateString: String) -> Date? {
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: dateString) {
            return date
        }
        return nil
    }
    
    func postCardDateString(dateString: String) -> String {
        if let date = convertDateString(dateString: dateString) {
            formatter.dateFormat = "MM월 dd일 EEEE"
            return formatter.string(from: date)
        }
        return ""
    }
    
    func getPostDateString(dateString: String) -> String {
        if let date = convertDateString(dateString: dateString) {
            formatter.dateFormat = "yyyy년 MM월 dd일 (E) a h:mm"
            return formatter.string(from: date)
        }
        return ""
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
        case .weekly: getWeekDateRange(date: date)
        case .monthly: getDateString(date: date, type: type)
        }
    }
    
    // 주간 기간 string 얻기
    private func getWeekDateRange(date: Date) -> String {
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
    
    func getYearMonth(date: Date) -> (year: Int, month: Int) {
        return (calendar.component(.year, from: date), calendar.component(.month, from: date))
    }
    
    // 현재 달 날짜수
    func getCurrentMonthDayCount() -> Int {
        if let range = calendar.range(of: .day, in: .month, for: date) {
            let numberOfDaysInMonth = range.count
            return numberOfDaysInMonth
        }
        return 0
    }
    
    func getDifferenceDayCount(from startDate: Date, to endDate: Date) -> Int {
        return calendar.dateComponents([.day], from: startDate, to: endDate).day ?? 0
    }
    
    // 기간 시트 날짜 리스트
    func getDateList(type: RecordType) -> [String] {
        var dateList: [String] = []
        let today = Date()
        
        if type == .monthly {
            for i in 0..<5 {
                if let monthAgo = calendar.date(byAdding: .month, value: -i, to: today) {
                    dateList.append(getDateString(date: monthAgo, type: type))
                }
            }
        } else {
            for i in 0..<5 {
                if let weekAgo = calendar.date(byAdding: .day, value: -7 * i, to: today) {
                    dateList.append(getWeekDateRange(date: weekAgo))
                }
            }
        }
        return dateList
    }
    
    func updateDate(index: Int, type: RecordType) {
        let today = Date()
        if type == .monthly {
            date = calendar.date(byAdding: .month, value: -index, to: today) ?? today
        } else {
            date = calendar.date(byAdding: .day, value: -index * 7, to: today) ?? today
        }
    }
    
    // 달 이동
    func moveMonth(date: Date, index: Int) -> Date {
        return calendar.date(byAdding: .month, value: -index, to: date) ?? date
    }
    
    func setDateToday() {
        date = Date()
    }
    
    // 날짜에 해당하는 달의 첫 날짜와 끝 날짜 yyyy-MM-dd 형식으로 반환
    func currentMonthFirstAndLastDateString(date: Date) -> (firstDayOfMonth: String, lastDayOfMonth: String) {
        if let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: date)),
           let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate) {
            formatter.dateFormat = "yyyy-MM-dd"
            return (formatter.string(from: startDate), formatter.string(from: endDate))
        }
        return ("", "")
    }
}
