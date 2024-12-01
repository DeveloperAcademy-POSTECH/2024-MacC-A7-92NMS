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
    @Published var currentDate = Date() {
        didSet {
            updateDailyRecord()
        }
    }
    @Published var selectedDate = Date()
    @Published var weeks: [[Date]] = []
    
    @Published var dailyRecord: DailyStressRecord?
    @Published var stressTrendData: [(Date, StressLevel)] = []
    
    @Published private var dailyData: [String: DailyData] = [:]

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
    
    let calendar = Date.calendar
    
    private let healthKitManager: HealthKitInterface
    private let mindfulSessionManager: MindfulSessionInterface
    
    init(_ healthKitManager: HealthKitInterface, _ mindfulSessionManager: MindfulSessionInterface) {
        self.healthKitManager = HealthKitManager()
        self.mindfulSessionManager = MindfulSessionManager()
        
        let thisWeek = getCurrentWeek()
        weeks = [thisWeek]
        
        updateDailyRecord()
    }
    

    
    // MARK: - HRV 데이터 처리
    private func updateDailyRecord() {
        /// HRV 데이터 가져오기
        healthKitManager.fetchDailyHRV(for: currentDate) { [weak self] samples, hrvError in
            guard let self = self else { return }
            
            if let hrvError = hrvError {
                print("Error fetching daily HRV data: \(hrvError.localizedDescription)")
                return
            }
            
            // TODO: DispatchGroup 고려
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
            
            /// 마음챙기기 데이터 가져오기
            self.mindfulSessionManager.fetchMindfulSessions(for: self.currentDate) { sessions, mindError in
                if let mindError = mindError {
                    print("Error fetching daily mindSession data: \(mindError.localizedDescription)")
                    return
                }
                
                DispatchQueue.main.async {
                    let sortedSamples = samples.sorted { $0.startDate < $1.startDate }
                    
                    /// 일일 스트레스 추이
                    self.stressTrendData = sortedSamples.map { sample in
                        let hrvValue = sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli))
                        let stressLevel = StressLevel.getLevel(from: hrvValue)
                        return (sample.startDate, stressLevel)
                    }
                    
                    /// 일일 마음 청소 통계 업데이트
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
}

// MARK: - 주간 달력
extension DailyStatisticsViewModel {
    func getCurrentWeek() -> [Date] {
        // 현재 요일을 기준으로 그 주의 월요일 찾기
        let weekday = calendar.component(.weekday, from: currentDate)
        let mondayOffset = weekday == 1 ? -6 : 2 - weekday // 일요일(1)이면 -6, 아니면 2에서 현재 요일을 뺀 값
        
        let currentMonday = calendar.date(byAdding: .day, value: mondayOffset, to: currentDate)!
        
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
            currentDate = date // currentDate 변경 시 자동으로 loadDailyHRVData() 호출
        }
    }
}


// MARK: - 월간 달력
extension DailyStatisticsViewModel {
    var currentMonth: Date {
        let components = calendar.dateComponents([.year, .month], from: Date())
        return calendar.date(from: components)!
    }
    
    var currentMonthOffset: Int {
        let startDate = calendar.date(byAdding: .month, value: -50, to: currentMonth)!
        let components = calendar.dateComponents([.month], from: startDate, to: Date())
        return components.month ?? 0
    }
    
    func getCalendarMonths() -> [Date] {
        (-50...1).compactMap { monthOffset in
            calendar.date(byAdding: .month, value: monthOffset, to: currentMonth)
        }
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
                return .white.opacity(0.2)  // 오늘 날짜는 투명한 흰색 배경
            }
            return .clear  // 나머지 날짜는 투명 배경
        }
}

// MARK: - 월간 달력 호흡 데이터
extension DailyStatisticsViewModel {
    // 날짜별 데이터 구조체
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
        
        // 이미 로드된 데이터가 있거나 미래 날짜인 경우 스킵
        guard dailyData[key] == nil, date <= Date() else { return }
        
        // 로딩 시작을 표시
        DispatchQueue.main.async {
            self.dailyData[key] = DailyData(recommendedCount: 0, completedCount: 0)
        }
        
        healthKitManager.fetchDailyHRV(for: date) { [weak self] samples, hrvError in
            guard let self = self else { return }
            
            if let hrvError = hrvError {
                print("Error fetching daily HRV data: \(hrvError.localizedDescription)")
                return
            }
            
            guard let samples = samples else {
                return
            }
            
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
