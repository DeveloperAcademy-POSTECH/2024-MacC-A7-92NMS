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
        
    @Published var dailyRecord: DailyStressRecord?
    
    var recommendedCount: Int {
        return dailyRecord?.recommendedReliefCount ?? 0
    }
    
    var completedCount: Int {
        return dailyRecord?.completedReliefCount ?? 0
    }
    
    var mindDustLevel: String {
        return dailyRecord?.mindDustLevel.assetName ?? MindDustLevel.none.assetName
    }
    
    var mindDustLvDescription: String {
        return dailyRecord?.mindDustLevel.description ?? MindDustLevel.none.description
    }
    
    // 이용하는 서비스들
    private let healthKitManager: HealthKitInterface
    private let mindfulSessionManager: MindfulSessionInterface
    
    init(_ healthKitManager: HealthKitInterface, _ mindfulSessionManager: MindfulSessionInterface) {
        self.healthKitManager = HealthKitManager()
        self.mindfulSessionManager = MindfulSessionManager()
    }
    

    func updateTodayRecord() {
        /// HRV 데이터 가져오기
        healthKitManager.fetchDailyHRV(for: Date()) { [weak self] samples, hrvError in
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
                        date: Date(),
                        recommendedReliefCount: 0,
                        completedReliefCount: 0
                    )
                }
                return
            }
            
            /// 마음챙기기 데이터 가져오기
            self.mindfulSessionManager.fetchMindfulSessions(for: Date()) { sessions, mindError in
                if let mindError = mindError {
                    print("Error fetching daily mindSession data: \(mindError.localizedDescription)")
                    return
                }
                
                DispatchQueue.main.async {
                    /// 일일 마음 청소 통계 업데이트
                    let highStressSamples = samples.filter { sample in
                        let hrvValue = sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli))
                        let stressLevel = StressLevel.getLevel(from: hrvValue)
                        return stressLevel == .high || stressLevel == .extreme
                    }
                    
                    self.dailyRecord = DailyStressRecord(
                        date: Date(),
                        recommendedReliefCount: highStressSamples.count,
                        completedReliefCount: sessions?.count ?? 0
                    )
                }
            }
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
