//
//  HealthKitManager.swift
//  Spha
//
//  Created by 지영 on 11/12/24.
//

import Foundation
import HealthKit
import UserNotifications

protocol HealthKitInterface {
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) // HealthKit 관련 권한 요청
    func fetchDailyHRV(for date: Date, completion: @escaping ([HKQuantitySample]?, Error?) -> Void) // 일간 HRV 데이터 요청
    func fetchMonthlyHRV(for month: Date, completion: @escaping ([HKQuantitySample]?, Error?) -> Void) // 월간 HRV 데이터 요청
    func monitorHRVUpdates() // HRV 업데이트 모니터링
    func didUpdateHRVData(completion: @escaping () -> Void)
}

class HealthKitManager: HealthKitInterface {
    
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()
    
    private var isProcessingHRVUpdate: Bool = false
    private let queue = DispatchQueue(label: "com.healthkitManager.queue", attributes: .concurrent)
    private var lastProcessedHRVTimestamp: Date?
    private var appInstallationDate: Date {
            let defaults = UserDefaults.standard
            let key = "HealthKitManagerInstallationDate"
            
            if let savedDate = defaults.object(forKey: key) as? Date {
                return savedDate
            } else {
                let now = Date()
                defaults.set(now, forKey: key)
                return now
            }
        }
    
        
    // 권한 요청 메소드
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, NSError(domain: "HealthKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "Health data is not available on this device."]))
            return
        }
        
        // 읽기 및 쓰기 권한이 필요한 데이터 타입
        guard let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN),
              let mindfulnessType = HKObjectType.categoryType(forIdentifier: .mindfulSession) else {
            completion(false, NSError(domain: "HealthKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to create HRV or Mindfulness data types."]))
            return
        }
        
        let readTypes: Set<HKObjectType> = [hrvType, mindfulnessType]
        let shareTypes: Set<HKSampleType> = [hrvType, mindfulnessType]
        
        // 권한 요청
        healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) { success, error in
            if let error = error {
                print("Error requesting HealthKit authorization: \(error.localizedDescription)")
                completion(false, error)
            } else {
                print("HealthKit authorization was \(success ? "successful" : "unsuccessful").")
                // HRV 데이터 백그라운드 전달 활성화
                self.enableBackgroundHRVDelivery()
                // HRV 데이터 변경 관찰 시작
                self.monitorHRVUpdates()
                
                completion(success, nil)
            }
        }
    }
    
    // 백그라운드 전달 활성화
    func enableBackgroundHRVDelivery() {
        guard let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else { return }
        healthStore.enableBackgroundDelivery(for: hrvType, frequency: .immediate) { success, error in
            if let error = error {
                print("Error enabling background delivery: \(error.localizedDescription)")
            } else {
                if success {
                    print("HRV 데이터 백그라운드 전달이 활성화되었습니다.")
                } else {
                    print("HRV 데이터 백그라운드 전달이 실패했습니다.")
                }
            }
        }
    }
}

// MARK: - HRV 데이터 요청
extension HealthKitManager {
    // 특정 날짜의 HRV 데이터 요청
    func fetchDailyHRV(for date: Date, completion: @escaping ([HKQuantitySample]?, Error?) -> Void) {
        guard let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else {
            completion(nil, nil)
            return
        }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: hrvType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, results, error in
            if let samples = results as? [HKQuantitySample] {
                completion(samples, nil)
            } else {
                completion(nil, error)
            }
        }
        
        healthStore.execute(query)
    }
    
    // 특정 달의 HRV 데이터 요청
    func fetchMonthlyHRV(for month: Date, completion: @escaping ([HKQuantitySample]?, Error?) -> Void) {
        guard let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else {
            completion(nil, nil)
            return
        }
        
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month))!
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfMonth, end: endOfMonth, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: hrvType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, results, error in
            if let samples = results as? [HKQuantitySample] {
                completion(samples, nil)
            } else {
                completion(nil, error)
            }
        }
        
        healthStore.execute(query)
    }
    
    // 가장 최근 HRV 데이터를 가져오는 메서드
    func fetchLatestHRV(completion: @escaping (HKQuantitySample?, Error?) -> Void) {
        guard let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else {
            completion(nil, NSError(domain: "HealthKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "HRV 타입을 찾을 수 없습니다."]))
            return
        }
        
        // 가장 최근 데이터를 가져오기 위해 정렬
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        // 가장 최근 데이터 1개만 가져옴
        let query = HKSampleQuery(sampleType: hrvType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, results, error in
            if let sample = results?.first as? HKQuantitySample {
                completion(sample, nil)
            } else {
                completion(nil, error)
            }
        }
        
        healthStore.execute(query)
    }
}

// MARK: - HRV 측정 옵저버
extension HealthKitManager {
    
    func monitorHRVUpdates() {
        guard let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else { return }
        
        let query = HKObserverQuery(sampleType: hrvType, predicate: nil) {  _, completionHandler, error in
            if let error = error {
                print("Error observing HRV updates: \(error.localizedDescription)")
                completionHandler()
                return
            }
            
            // HRV 데이터 업데이트 시 알림 전송 (비동기 작업을 순차적으로 처리)
            HealthKitManager.shared.queue.async {
                HealthKitManager.shared.didUpdateHRVData {
                    completionHandler()
                }
            }
        }
        
        healthStore.execute(query)
    }
    
    
    func didUpdateHRVData(completion: @escaping () -> Void) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            guard !self.isProcessingHRVUpdate else {
                print("이미 HRV 업데이트 처리 중")
                completion()
                return
            }
            self.isProcessingHRVUpdate = true
        }

        HealthKitManager.shared.fetchLatestHRV { [weak self] sample, error in
            guard let self = self else {
                completion()
                return
            }

            defer {
                self.queue.async(flags: .barrier) {
                    self.isProcessingHRVUpdate = false
                }
                completion()
            }

            guard let sample = sample else {
                print("샘플이 nil임")
                return
            }

            print("HRV 샘플 받음: \(sample.endDate)")
            print("앱 설치 날짜: \(self.appInstallationDate)")

            guard sample.endDate >= self.appInstallationDate else {
                print("설치 이전 데이터라 무시됨")
                return
            }

            if let lastTimestamp = self.lastProcessedHRVTimestamp,
               lastTimestamp >= sample.endDate {
                print("이미 처리된 timestamp라 무시됨")
                return
            }

            let hrvValue = sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli))
            print("HRV 값: \(hrvValue)")

            if hrvValue < 45 {
                self.lastProcessedHRVTimestamp = sample.endDate
                NotificationManager.shared.sendBreathingAlert()
                print("알림 전송됨")
            }
        }
    }
}

//MARK: - watchOS WorkoutSession 권한 요청
extension HealthKitManager {
    func requestWatchWorkoutSessionAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, NSError(domain: "HealthKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "Health data is not available."]))
            return
        }
        
        let typesToShare: Set = [HKObjectType.workoutType()]
        let typesToRead: Set = [HKObjectType.workoutType()]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            completion(success, error)
        }
    }
}
