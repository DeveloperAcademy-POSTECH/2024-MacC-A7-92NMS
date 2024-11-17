//
//  WeeklyCalendarHeaderViewModel.swift
//  Spha
//
//  Created by 지영 on 11/17/24.
//

import Foundation

class WeeklyCalendarHeaderViewModel: ObservableObject {
    @Published var weeks: [[Date]] = []
    private let calendar = Date.calendar
    private var lastestDate: Date
        
    init() {
        let today = Date()
        
        var weekInterval = calendar.dateInterval(of: .weekOfYear, for: today)!
        lastestDate = weekInterval.end
        
        generateInitialWeeks(from: today)
    }

    private func generateInitialWeeks(from date: Date) {
        var currentWeeks: [[Date]] = [] // 이전 2주 포함 현재 주
        
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        guard let startOfCurrentWeek = calendar.date(from: components) else { return }
        
        // 현재 주 추가
        currentWeeks.append(generateWeek(from: startOfCurrentWeek))
        
        // 2주 전
        guard let twoWeeksAgoStart = calendar.date(byAdding: .weekOfYear, value: -2, to: startOfCurrentWeek) else { return }
        
        // 1주 전
        guard let oneWeekAgoStart = calendar.date(byAdding: .weekOfYear, value: -1, to: startOfCurrentWeek) else { return }
        
        currentWeeks.insert(generateWeek(from: twoWeeksAgoStart), at: 0)
        currentWeeks.insert(generateWeek(from: oneWeekAgoStart), at: 1)
        
        weeks = currentWeeks
    }
    
    /// 시작 날짜로 부터 일주일치 날짜 배열 만드는 메서드
    private func generateWeek(from startDate: Date) -> [Date] {
        var week: [Date] = []
        
        for dayCount in 0...6 {
            if let date = calendar.date(byAdding: .day, value: dayCount, to: startDate) {
                week.append(date)
            }
        }
        
        return week
    }
    
    func loadPastWeeks() {
        guard let firstWeek = weeks.first,
              let firstDate = firstWeek.first,
              let previousWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: firstDate) else { return }
        
        let previousWeek = generateWeek(from: previousWeekStart)
        weeks.insert(previousWeek, at: 0)
    }
    
    func canScrollToDate(_ date: Date) -> Bool {
        return date <= lastestDate
    }
 
}
