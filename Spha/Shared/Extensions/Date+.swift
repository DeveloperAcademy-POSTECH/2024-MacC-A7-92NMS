//
//  Date+.swift
//  Spha
//
//  Created by 지영 on 11/15/24.
//

import Foundation

extension Date {
    // DateFormatter 인스턴스를 재사용하기 위해 static으로 선언
    private static let fullFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ko_KR")
        formatter.dateFormat = NSLocalizedString("date_format_full", comment: "yyyy년 MM월 dd일")
        return formatter
    }()
    
    private static let todayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ko_KR")
        formatter.dateFormat = NSLocalizedString("date_format_today", comment: "yyyy년 MM월 dd일 오늘")
        return formatter
    }()
    
    static let calendarMonthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = NSLocalizedString("date_format_month", comment: "YYYY년 M월")
        return formatter
    }()
    
    // Calendar 인스턴스도 재사용
    static let calendar = Calendar.current
    
    var dateTitleString: String {
        // 오늘 날짜와 비교
        if Date.calendar.isDate(self, inSameDayAs: Date()) {
            return Date.todayFormatter.string(from: self)
        } else {
            return Date.fullFormatter.string(from: self)
        }
    }
    
    /// 달력에 필요한 요일 문자열 반환
    var dayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ko_KR")
        formatter.dateFormat = "E"
        return formatter.string(from: self).uppercased()
    }
    
    /// 달력에 필요한 날짜 문자열 반환
    var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: self)
    }
    
    static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = NSLocalizedString("date_format_month_short", comment: "M월")
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ko_KR")
        return formatter
    }()
    
    var monthString: String {
        return Date.monthFormatter.string(from: self)
    }
    
    static func getWeekdayHeadersStartingMonday() -> [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ko_KR")
        var weekdays = formatter.shortWeekdaySymbols
        if let sunday = weekdays?.removeFirst() {
            weekdays?.append(sunday)
        }
        return weekdays?.map { $0.uppercased() } ?? []
    }
    
    static func dateKey(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

