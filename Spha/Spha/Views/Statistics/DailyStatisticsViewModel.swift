//
//  DailyStatisticsViewModel.swift
//  Spha
//
//  Created by 지영 on 11/21/24.
//

import Foundation
import HealthKit

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
    
    // MARK: - 주간 달력
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
            currentDate = date // currentDate 변경 시 자동으로 loadDailyHRVData() 호출
        }
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
