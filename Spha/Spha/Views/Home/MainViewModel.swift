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
            
            print("@@@@ samples : \(samples)")
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
}
