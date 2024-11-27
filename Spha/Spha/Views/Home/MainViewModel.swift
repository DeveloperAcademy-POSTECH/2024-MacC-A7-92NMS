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
    @Published var recommendedCleaningCount: Int = 0
    @Published var actualCleaningCount: Int = 0
    @Published var isHRVDataExists: Bool = false
    
    // 계산 속성: 남은 청소 횟수
    var remainingCleaningCount: MindDustLevel {
        if !isHRVDataExists { return .none }
        
        let count = recommendedCleaningCount - actualCleaningCount
        
        if count <= 0 { return .dustLevel1}
        
        switch count {
        case 1:
            return .dustLevel2
        case 2:
            return .dustLevel3
        case 3:
            return .dustLevel4
        default:
            return .dustLevel5
        }
    }
    
    // 이용하는 서비스들
    let healthKitManager = HealthKitManager()
    let mindfulSessionManager = MindfulSessionManager()

    let stressSdnnValue: Double = 40
    
    // DailyHRVData 요청
    func fetchTodayHRVData() {
        healthKitManager.fetchDailyHRV(for: Date()) { samples, error in
            if let error = error {
                print("Error fetching daily HRV data: \(error.localizedDescription)")
            } else if let samples = samples {
                
                DispatchQueue.main.async {
                    self.isHRVDataExists = true
                }
                
                var stressCount: Int = 0
                for sample in samples {
                    let sdnnValue = sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli))
                    if sdnnValue > self.stressSdnnValue {
                        stressCount += 1
                    }
                }
                DispatchQueue.main.async {
                    self.recommendedCleaningCount = stressCount
                }
                print("Successfully fetched today's HRV data.")
            } else {
                DispatchQueue.main.async {
                    self.recommendedCleaningCount = 0
                }
                print("No daily HRV data available.")
            }
        }
    }
    
    // DailyMindfulSession 요청
    func fetchTodaySessions() {
        mindfulSessionManager.fetchMindfulSessions(for: Date()) { sessions, error in
            if let error = error {
                print("Error fetching today's sessions: \(error.localizedDescription)")
            } else if let sessions = sessions {
                DispatchQueue.main.async {
                    self.actualCleaningCount = sessions.count
                }
            } else {
                DispatchQueue.main.async {
                    self.actualCleaningCount = 0
                }
                print("No sessions found for today.")
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
