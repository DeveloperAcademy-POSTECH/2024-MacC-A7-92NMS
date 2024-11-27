//
//  WatchMainStatusViewModel.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/22/24.
//

import Foundation
import HealthKit

class WatchMainStatusViewModel: ObservableObject {
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

    let stressSdnnValue: Double = 40
    
    // DailyHRVData 요청
    func fetchTodayHRVData() {
        HRVService.fetchDailyHRV(for: Date()) { samples, error in
            if let error = error {
                print("Error fetching daily HRV data: \(error.localizedDescription)")
            } else if let samples = samples {
                
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
        MindfulService.fetchMindfulSessions(for: Date()) { sessions, error in
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
