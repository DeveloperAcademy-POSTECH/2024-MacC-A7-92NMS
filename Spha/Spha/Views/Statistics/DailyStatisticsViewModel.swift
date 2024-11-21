//
//  DailyStatisticsViewModel.swift
//  Spha
//
//  Created by 지영 on 11/21/24.
//

import Foundation

class DailyStatisticsViewModel: ObservableObject {
    @Published var currentDate = Date()
    @Published var selectedDate = Date()
    @Published var weeks: [[Date]] = []
    
    let calendar = Date.calendar
    
    init() {
        let thisWeek = getCurrentWeek()
        weeks = [thisWeek]
    }
    
    func getCurrentWeek() -> [Date] {
        let today = Date()
        // 일단 일요일
        var currentMonday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        
        // 월요일 찾기
        // 1: 일요일 2: 월요일 3: 화요일 4: 수요일 5: 목요일 6: 금요일 7: 토요일
        if calendar.component(.weekday, from: currentMonday) != 2 { // 현재 날짜가 월요일이 아니면, 월요일로 이동
            currentMonday = calendar.date(byAdding: .day,
                                          // 2(월요일) - 현재 요일 = 이동해야 할 일수
                                          value: 2 - calendar.component(.weekday, from: currentMonday),
                                          to: currentMonday)!
        }
        
        // 월요일부터 일주일 날짜 배열 만들기
        return (0..<7).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: currentMonday)
        }
    }
    
    func loadPreviousWeek() {
        guard let firstWeekMonday = weeks.first?.first else { return }
        let previousMonday = calendar.date(byAdding: .weekOfYear, value: -1, to: firstWeekMonday)!
        
        let newWeek = (0..<7).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: previousMonday)
        }
        weeks.insert(newWeek, at: 0)
    }
    
    func handleDateTap(_ date: Date) {
        if date <= Date() {
            print(date.dateTitleString)
            currentDate = date
        }
    }
    
}
