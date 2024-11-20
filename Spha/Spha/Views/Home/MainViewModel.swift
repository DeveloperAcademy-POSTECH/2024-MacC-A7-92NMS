//
//  MainViewModel.swift
//  Spha
//
//  Created by LDW on 11/20/24.
//

import Foundation
import HealthKit

class MainViewModel: ObservableObject {
    @Published var showBreathingIntro = false
    @Published var breathingIntroOpacity: Double = 0.0
    @Published var recommendedCleaningCount: Int = 0
    @Published var actualCleaningCount: Int = 0

    // 계산 속성: 남은 청소 횟수
    var remainingCleaningCount: MindDustLevel {
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
    let HRVService = HealthKitManager()
    let MindfulService = MindfulSessionManager()
    
    // DailyHRVData 요청
    private func fetchTodayHRVData() {
        HRVService.fetchDailyHRV(for: Date()) { samples, error in
            if let error = error {
                print("Error fetching daily HRV data: \(error.localizedDescription)")
            } else if let samples = samples {
                
                var stressCount: Int = 0
                
                for sample in samples {
                    let sdnnValue = sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli))
                    if sdnnValue > 40 {
                        stressCount += 1
                    }
                }
                
                self.recommendedCleaningCount = stressCount
                
                print("Successfully fetched today's HRV data.")
            } else {
                print("No daily HRV data available.")
            }
        }
    }
    
    // DailyMindfulSession 요청
    private func fetchTodaySessions() {
        MindfulService.fetchMindfulSessions(for: Date()) { sessions, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching today's sessions: \(error.localizedDescription)")
                } else if let sessions = sessions {
                    self.actualCleaningCount = sessions.count
                } else {
                    self.actualCleaningCount = 0
                    print("No sessions found for today.")
                }
            }
        }
    }
    
    // BreathingIntroView 상태 초기화 및 페이드인
    func resetBreathingIntro() {
        showBreathingIntro = false
        breathingIntroOpacity = 0.0
    }
    
    // BreathingIntroView 시작
    func startBreathingIntro() {
        showBreathingIntro = true
        breathingIntroOpacity = 0.0 // 초기화
    }

}
