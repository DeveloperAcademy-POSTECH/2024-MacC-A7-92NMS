//
//  MainViewModel.swift
//  Spha
//
//  Created by LDW on 11/20/24.
//

import Foundation
import HealthKit
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var showBreathingIntro = false
    @Published var breathingIntroOpacity: Double = 0.0
    @Published var isHRVRecordedToday = false
    @Published var dailyRecord: DailyStressRecord
    @Published var isChangedData: Bool = false
    
    var recommendedCount: Int {
        return dailyRecord.recommendedReliefCount
    }
    
    var completedCount: Int {
        return dailyRecord.completedReliefCount
    }
    
    var mindDustLevel: String {
        if !isHRVRecordedToday { return MindDustLevel.none.assetName }
        return dailyRecord.mindDustLevel.assetName
        
    }
    
    var mindDustLvDescription: String {
        if !isHRVRecordedToday { return MindDustLevel.none.description }
        return dailyRecord.mindDustLevel.description
    }
    
    // 이용하는 서비스들
    private let healthKitManager: HealthKitInterface
    private let mindfulSessionManager: MindfulSessionInterface
    
    init(_ healthKitManager: HealthKitInterface, _ mindfulSessionManager: MindfulSessionInterface) {
        self.healthKitManager = HealthKitManager()
        self.mindfulSessionManager = MindfulSessionManager()
        self.dailyRecord = DailyStressRecord(date: Date(), recommendedReliefCount: 0, completedReliefCount: 0)
    }
    
    func updateTodayRecord() {
        let dispatchGroup = DispatchGroup() // DispatchGroup 생성
        var hrvSamples: [HKQuantitySample] = []
        var mindfulSessions: [HKCategorySample] = []
        
        
        /// HRV 데이터 가져오기
        dispatchGroup.enter()
        healthKitManager.fetchDailyHRV(for: Date()) { [weak self] samples, hrvError in
            defer { dispatchGroup.leave() }
            guard let self = self else { return }
            
            if let hrvError = hrvError {
                print("Error fetching daily HRV data: \(hrvError.localizedDescription)")
                return
            }

            guard let samples = samples else {
                print("바인딩 실패")
                return
            }
            
            DispatchQueue.main.async {
                self.isHRVRecordedToday = samples.isEmpty ? false : true
            }

            hrvSamples = samples
        }
        
        /// 마음챙기기 데이터 가져오기
        dispatchGroup.enter()
        mindfulSessionManager.fetchMindfulSessions(for: Date()) { sessions, mindError in
            defer { dispatchGroup.leave() } // 작업 완료 시 그룹 나가기
            if let mindError = mindError {
                print("Error fetching daily mindSession data: \(mindError.localizedDescription)")
                return
            }
            
            guard let sessions = sessions else {
                print("updateTodayRecord(): MindfulSession 데이터 없음")
                return
            }
            
            mindfulSessions = sessions
        }
        
        dispatchGroup.notify(queue: .main) {
            /// 일일 마음 청소 통계 업데이트
            let highStressSamples = hrvSamples.filter { sample in
                let hrvValue = sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli))
                let stressLevel = StressLevel.getLevel(from: hrvValue)
                return stressLevel == .high || stressLevel == .extreme
            }
            
            self.dailyRecord.recommendedReliefCount = highStressSamples.count
            self.dailyRecord.completedReliefCount = mindfulSessions.count
        }
    }
    
    // BreathingIntroView 상태 초기화 및 페이드인
    func resetBreathingIntro() {
        DispatchQueue.main.async {
            self.showBreathingIntro = false
            self.breathingIntroOpacity = 0.0
        }
    }
    
    // BreathingIntroView 시작
    func startBreathingIntro(router: RouterManager) {
            showBreathingIntro = true
            breathingIntroOpacity = 0.0
            // 페이드인 애니메이션
            withAnimation(.easeIn(duration: 1.0)) {
                breathingIntroOpacity = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                router.push(view: .breathingMainView)
            }
        }
    
    // MARK: - 쇼케이스용 HRV 데이터 기록
    func recordTestHRVData() {
        healthKitManager.recordTestHRV { success, error in
            if success {
                print("Test HRV data recorded successfully.")
                DispatchQueue.main.async {
                    self.isChangedData.toggle()
                    self.updateTodayRecord()   // 최신 데이터 반영
                }
            } else if let error = error {
                print("Error recording test HRV data: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - 쇼케이스용 MindfulSession 데이터 기록
    func recordTestMindfulSessionData() {
        mindfulSessionManager.recordMindfulSession(startDate: Date(), endDate: Date() + 60) { success, error in
            if success {
                print("Test mindfulSession data recorded successfully.")
                DispatchQueue.main.async {
                    self.isChangedData.toggle()
                    self.updateTodayRecord()   // 최신 데이터 반영
                }
            } else if let error = error {
                print("Error recording test mindfulSession data: \(error.localizedDescription)")
            }
        }
    }
    
    func resetTodayDataAll() {
        let dispatchGroup = DispatchGroup() // DispatchGroup 생성
        
        dispatchGroup.enter()
        mindfulSessionManager.deleteDailyMindfulSessions(for: Date()) { success, error in
            defer { dispatchGroup.leave() }
            if success {
                print("Today's mindful session data deleted successfully.")
            } else if let error = error {
                print("Error deleting today's mindful session data: \(error.localizedDescription)")
            }
        }
        
        dispatchGroup.enter()
        healthKitManager.deleteDailyHRV(for: Date()) { success, error in
            defer { dispatchGroup.leave() }
            if success {
                print("Today's HRV data deleted successfully.")
            } else if let error = error {
                print("Error deleting today's HRV data: \(error.localizedDescription)")
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("All today's records deleted successfully.")
            self.updateTodayRecord() // 데이터 삭제 후 화면 업데이트
        }
    }
}
