//
//  DailyStatisticsViewModel.swift
//  Spha
//
//  Created by 지영 on 11/21/24.
//

import Foundation
import HealthKit
import SwiftUI

class DailyStatisticsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentDate = Date() {
        didSet {
            updateDailyRecord()
        }
    }
    @Published var selectedDate = Date()
    @Published var weeks: [[Date]] = []
    @Published var availableDates: [Date] = []
    @Published var dailyRecord: DailyStressRecord?
    @Published var stressTrendData: [(Date, StressLevel)] = []
    @Published private var dailyData: [String: DailyData] = [:]
    
    // MARK: - Properties
    let calendar = Date.calendar
    private let healthKitManager: HealthKitInterface
    private let mindfulSessionManager: MindfulSessionInterface
    
    // MARK: - Computed Properties
    var breathingRatio: CGFloat {
        guard let record = dailyRecord,
              record.recommendedReliefCount > 0 else {
            return 0.0
        }
        return CGFloat(record.completedReliefCount) / CGFloat(record.recommendedReliefCount)
    }
    
    var recommendedCount: Int {
        return dailyRecord?.recommendedReliefCount ?? 0
    }
    
    var completedCount: Int {
        return dailyRecord?.completedReliefCount ?? 0
    }
    
    var extremeCount: Int {
        return stressTrendData.filter { $0.1 == .extreme }.count
    }
    
    var mindDustLevel: String {
        return dailyRecord?.mindDustLevel.assetName ?? MindDustLevel.none.assetName
    }
    
    // MARK: - Initialization
    init(_ healthKitManager: HealthKitInterface, _ mindfulSessionManager: MindfulSessionInterface) {
        self.healthKitManager = HealthKitManager()
        self.mindfulSessionManager = MindfulSessionManager()
        
        // 현재 주만 초기화
        let thisWeek = getCurrentWeek()
        weeks = [thisWeek]
        selectedDate = thisWeek[0]
        
        initializeAvailableDates()
        loadPreviousWeek() // 초기에 이전 주 하나 로드
        
        updateDailyRecord()
    }
    
    // MARK: - 날짜 관리
    private func initializeAvailableDates() {
        // 현재 주의 모든 날짜를 포함하도록 초기화
        let currentWeekDates = getCurrentWeekDates()
        availableDates = currentWeekDates.filter { $0 <= Date() }
        
        // 이전 주의 날짜들도 미리 로드
        if let mondayOfCurrentWeek = currentWeekDates.first {
            let previousWeekDates = (-7...0).compactMap { offset in
                calendar.date(byAdding: .day, value: offset, to: mondayOfCurrentWeek)
            }
            availableDates = (previousWeekDates + availableDates).filter { $0 <= Date() }
        }
        
        // 중복 제거 및 정렬
        availableDates = Array(Set(availableDates)).sorted()
    }
    
    func getCurrentWeek() -> [Date] {
        let weekday = calendar.component(.weekday, from: currentDate)
        let mondayOffset = weekday == 1 ? -6 : 2 - weekday
        let currentMonday = calendar.date(byAdding: .day, value: mondayOffset, to: currentDate)!
        
        return (0..<7).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: currentMonday)
        }
    }
    
    func updateWeekForDate(_ date: Date) {
        let newWeek = getWeekForDate(date)
        
        if !weeks.contains(where: { weekDates in
            calendar.isDate(weekDates[0], equalTo: newWeek[0], toGranularity: .day)
        }) {
            if let firstWeek = weeks.first, let firstDate = firstWeek.first,
               date < firstDate {
                weeks.insert(newWeek, at: 0)
            } else {
                weeks.append(newWeek)
            }
        }
        
        selectedDate = newWeek[0]
    }
    
    func getWeekForDate(_ date: Date) -> [Date] {
        let weekday = calendar.component(.weekday, from: date)
        let mondayOffset = weekday == 1 ? -6 : 2 - weekday
        let monday = calendar.date(byAdding: .day, value: mondayOffset, to: date)!
        
        return (0..<7).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: monday)
        }
    }
    
    func loadPreviousWeek() {
        guard let firstWeekMonday = weeks.first?.first else { return }
        let previousMonday = calendar.date(byAdding: .weekOfYear, value: -1, to: firstWeekMonday)!
        
        // 9월 1일 이전의 주는 로드하지 않음
        guard previousMonday >= startDate else { return }
        
        let newWeek = getWeekForDate(previousMonday)
        
        // 중복 체크 후 추가
        if !weeks.contains(where: { week in
            calendar.isDate(week[0], equalTo: newWeek[0], toGranularity: .day)
        }) {
            weeks.insert(newWeek, at: 0)
            
            // 이전 주의 날짜들을 availableDates에도 추가
            let newDates = newWeek.filter { $0 <= Date() && $0 >= startDate }
            availableDates.insert(contentsOf: newDates, at: 0)
            availableDates = Array(Set(availableDates)).sorted() // 중복 제거 및 정렬
        }
    }
    
    func handleDateTap(_ date: Date) {
        if date <= Date() {
            currentDate = date
        }
    }
    
    func getCurrentWeekDates() -> [Date] {
        if let currentWeek = weeks.first(where: { week in
            week.contains(where: { date in
                calendar.isDate(date, inSameDayAs: currentDate)
            })
        }) {
            return currentWeek
        }
        return []
    }
    
    func updateDates(for newDate: Date) {
        guard newDate <= Date() else { return }
        
        // 현재 날짜가 속한 주 찾기
        if let currentWeek = weeks.first(where: { week in
            week.contains { date in
                calendar.isDate(date, inSameDayAs: newDate)
            }
        }) {
            selectedDate = currentWeek[0]
            currentDate = newDate
            
            // 날짜가 첫 번째 주에 속하면 이전 주 로드
            if currentWeek[0] == weeks.first?[0] {
                loadPreviousWeek()
            }
        } else {
            // 새로운 주 로드가 필요한 경우
            let newWeek = getWeekForDate(newDate)
            
            if newDate < (weeks.first?[0] ?? Date()) {
                weeks.insert(newWeek, at: 0)
                selectedDate = newWeek[0]
                currentDate = newDate
                
                // 이전 주 미리 로드
                loadPreviousWeek()
                
                // availableDates 업데이트
                let newDates = newWeek.filter { $0 <= Date() }
                availableDates.insert(contentsOf: newDates, at: 0)
                availableDates = Array(Set(availableDates)).sorted()
            }
        }
        
        // 연속된 날짜 데이터 보장
        ensureContiguousDates(around: newDate)
    }
    
    // 새로 추가: 연속된 날짜 데이터 보장
    private func ensureContiguousDates(around date: Date) {
        let calendar = Calendar.current
        
        // 현재 날짜 기준 이전 7일만 확인
        let dateRange = (-7...0).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: date)
        }.filter { $0 <= Date() && $0 >= startDate }
        
        // 없는 날짜 추가
        for date in dateRange {
            if !availableDates.contains(where: { calendar.isDate($0, inSameDayAs: date) }) {
                availableDates.append(date)
            }
        }
        
        // 정렬
        availableDates = Array(Set(availableDates)).sorted()
    }
    
    // MARK: - HRV 데이터 처리
    private func updateDailyRecord() {
        healthKitManager.fetchDailyHRV(for: currentDate) { [weak self] samples, hrvError in
            guard let self = self else { return }
            
            if let hrvError = hrvError {
                print("Error fetching daily HRV data: \(hrvError.localizedDescription)")
                return
            }
            
            guard let samples = samples else {
                print("HRV 데이터 없음")
                DispatchQueue.main.async {
                    self.dailyRecord = DailyStressRecord(
                        date: self.currentDate,
                        recommendedReliefCount: 0,
                        completedReliefCount: 0
                    )
                    self.stressTrendData = []
                }
                return
            }
            
            self.mindfulSessionManager.fetchMindfulSessions(for: self.currentDate) { sessions, mindError in
                if let mindError = mindError {
                    print("Error fetching daily mindSession data: \(mindError.localizedDescription)")
                    return
                }
                
                DispatchQueue.main.async {
                    let sortedSamples = samples.sorted { $0.startDate < $1.startDate }
                    
                    self.stressTrendData = sortedSamples.map { sample in
                        let hrvValue = sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli))
                        let stressLevel = StressLevel.getLevel(from: hrvValue)
                        return (sample.startDate, stressLevel)
                    }
                    
                    let highStressSamples = samples.filter { sample in
                        let hrvValue = sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli))
                        let stressLevel = StressLevel.getLevel(from: hrvValue)
                        return stressLevel == .high || stressLevel == .extreme
                    }
                    
                    self.dailyRecord = DailyStressRecord(
                        date: self.currentDate,
                        recommendedReliefCount: highStressSamples.count,
                        completedReliefCount: sessions?.count ?? 0
                    )
                }
            }
        }
    }
    
    // MARK: - 월간 달력
    var currentMonth: Date {
        let components = calendar.dateComponents([.year, .month], from: Date())
        return calendar.date(from: components)!
    }
    
    // 시작 날짜를 2024년 9월 1일로 설정
    private var startDate: Date {
        let components = DateComponents(year: 2024, month: 9, day: 1)
        return calendar.date(from: components)!
    }
    
    func getCalendarMonths() -> [Date] {
        // 시작 날짜(9월)부터 현재 날짜의 다음 달까지의 모든 달을 생성
        var dates: [Date] = []
        var currentDate = startDate
        
        // 현재 달의 다음 달까지 생성
        let endDate = calendar.date(byAdding: .month, value: 1, to: currentMonth)!
        
        while currentDate <= endDate {
            dates.append(currentDate)
            guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentDate) else { break }
            currentDate = nextMonth
        }
        
        return dates
    }
    
    func getDaysInMonthStartingMonday(for date: Date) -> [(offset: Int, element: Date?)] {
        let range = calendar.range(of: .day, in: .month, for: date)!
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        var firstWeekday = calendar.component(.weekday, from: firstDayOfMonth) - 2
        if firstWeekday < 0 { firstWeekday += 7 }
        
        var days = Array(repeating: nil as Date?, count: firstWeekday)
        
        for day in 1...range.count {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                days.append(date)
            }
        }
        
        while days.count % 7 != 0 {
            days.append(nil)
        }
        
        return days.enumerated().map { ($0, $1) }
    }
    
    func getDayColor(for date: Date, isSelected: Bool) -> Color {
        if date > Date() {
            return .gray.opacity(0.3)
        }
        return isSelected ? .white : .white
    }
    
    func getCircleFillColor(for date: Date) -> Color {
        if calendar.isDate(date, inSameDayAs: Date()) {
            return .white.opacity(0.2)
        }
        return .clear
    }
    
    // MARK: - 월간 달력 호흡 데이터
    struct DailyData {
        let recommendedCount: Int
        let completedCount: Int
        
        var ratio: CGFloat {
            guard recommendedCount > 0 else { return 0.0 }
            return CGFloat(completedCount) / CGFloat(recommendedCount)
        }
    }
    
    func getBreathingRatio(for date: Date) -> CGFloat {
        return dailyData[Date.dateKey(date)]?.ratio ?? 0.0
    }
    
    func loadDailyRatio(for date: Date) {
        let key = Date.dateKey(date)
        
        guard dailyData[key] == nil, date <= Date() else { return }
        
        DispatchQueue.main.async {
            self.dailyData[key] = DailyData(recommendedCount: 0, completedCount: 0)
        }
        
        healthKitManager.fetchDailyHRV(for: date) { [weak self] samples, hrvError in
            guard let self = self else { return }
            
            if let hrvError = hrvError {
                print("Error fetching daily HRV data: \(hrvError.localizedDescription)")
                return
            }
            
            guard let samples = samples else { return }
            
            self.mindfulSessionManager.fetchMindfulSessions(for: date) { sessions, mindError in
                if let mindError = mindError {
                    print("Error fetching daily mindSession data: \(mindError.localizedDescription)")
                    return
                }
                
                let highStressSamples = samples.filter { sample in
                    let hrvValue = sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli))
                    let stressLevel = StressLevel.getLevel(from: hrvValue)
                    return stressLevel == .high || stressLevel == .extreme
                }
                
                let recommendedCount = highStressSamples.count
                let completedCount = sessions?.count ?? 0
                
                DispatchQueue.main.async {
                    self.dailyData[key] = DailyData(
                        recommendedCount: recommendedCount,
                        completedCount: completedCount
                    )
                }
            }
        }
    }
    
    func loadMonthData(for date: Date) {
        let daysInMonth = getDaysInMonthStartingMonday(for: date)
        
        for (_, dayDate) in daysInMonth {
            guard let dayDate = dayDate else { continue }
            if dayDate <= Date() {
                loadDailyRatio(for: dayDate)
            }
        }
    }
}
