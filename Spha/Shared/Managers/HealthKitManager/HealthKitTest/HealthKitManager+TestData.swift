//
//  HealthKitManager+TestData.swift
//  Spha
//
//  Created by LDW on 11/15/24.
//


import HealthKit
import UserNotifications

// MARK: - 테스트용 HealthKitManager 메서드 extension
extension HealthKitManager {
    
    // 테스트용 알림 허용
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification authorization error: \(error.localizedDescription)")
            }
            if granted {
                print("Notification authorization granted")
            } else {
                print("Notification authorization denied")
            }
        }
    }
    
    // 테스트용 HRV 데이터를 기록하는 메서드
    func recordTestHRV(completion: @escaping (Bool, Error?) -> Void) {
        guard let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else {
            completion(false, NSError(domain: "HealthKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "HRV 타입을 찾을 수 없습니다."]))
            return
        }
        
        // 임의의 HRV 데이터 생성 (임의값: 50ms)
        let hrvValue = HKQuantity(unit: HKUnit.secondUnit(with: .milli), doubleValue: 50.0)
        let now = Date()
        let sample = HKQuantitySample(type: hrvType, quantity: hrvValue, start: now, end: now)
        
        // 데이터를 HealthKit에 저장
        healthStore.save(sample) { success, error in
            if success {
                print("테스트 HRV 데이터가 기록되었습니다.")
            } else if let error = error {
                print("테스트 HRV 데이터 기록 오류: \(error.localizedDescription)")
            }
            completion(success, error)
        }
    }
}
