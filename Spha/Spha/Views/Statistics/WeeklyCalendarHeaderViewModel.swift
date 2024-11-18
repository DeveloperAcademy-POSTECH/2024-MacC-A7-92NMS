//
//  WeeklyCalendarHeaderViewModel.swift
//  Spha
//
//  Created by 지영 on 11/17/24.
//

import Foundation

class WeeklyCalendarHeaderViewModel: ObservableObject {
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
        var currentMonday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        if calendar.component(.weekday, from: currentMonday) != 2 {
            currentMonday = calendar.date(byAdding: .day, value: 2 - calendar.component(.weekday, from: currentMonday), to: currentMonday)!
        }
        
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
