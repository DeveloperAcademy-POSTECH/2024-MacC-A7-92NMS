//
//  MindfulSessionManager.swift
//  Spha
//
//  Created by LDW on 11/18/24.
//
import Foundation
import HealthKit

protocol MindfulSessionInterface {
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    func recordMindfulSession(startDate: Date, endDate: Date, completion: @escaping (Bool, Error?) -> Void) // Mindful Session 데이터 기록
    func fetchMindfulSessions(for date: Date, completion: @escaping ([HKCategorySample]?, Error?) -> Void) // 특정 날짜의 Mindful Session 데이터 조회
    func fetchMonthlyMindfulSessions(for month: Date, completion: @escaping ([HKCategorySample]?, Error?) -> Void) // 특정 달의 Mindful Session 데이터 조회
}

class MindfulSessionManager: MindfulSessionInterface {
    
    let healthStore = HKHealthStore()

    // MARK: - HealthKit 권한 요청
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession) else {
            print("Mindfulness session type is not available")
            return
        }
        
        let readWriteTypes: Set<HKSampleType> = [mindfulType]
        
        healthStore.requestAuthorization(toShare: readWriteTypes, read: readWriteTypes) { success, error in
            if success {
                completion(success)
                print("HealthKit authorization granted for Mindfulness sessions")
            } else if let error = error {
                print("HealthKit authorization failed: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Mindful Session 기록
    func recordMindfulSession(startDate: Date, endDate: Date, completion: @escaping (Bool, Error?) -> Void) {
        guard let mindfulType = HKCategoryType.categoryType(forIdentifier: .mindfulSession) else {
            completion(false, NSError(domain: "HealthKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mindfulness session type not available"]))
            return
        }
        
        let mindfulSample = HKCategorySample(
            type: mindfulType,
            value: HKCategoryValue.notApplicable.rawValue,
            start: startDate,
            end: endDate
        )
        
        healthStore.save(mindfulSample) { success, error in
            if success {
                print("Mindfulness session recorded successfully")
            } else if let error = error {
                print("Error recording mindfulness session: \(error.localizedDescription)")
            }
            completion(success, error)
        }
    }
    
    // MARK: - 특정 날짜의 Mindful Session 데이터 조회
    func fetchMindfulSessions(for date: Date, completion: @escaping ([HKCategorySample]?, Error?) -> Void) {
        guard let mindfulType = HKCategoryType.categoryType(forIdentifier: .mindfulSession) else {
            completion(nil, NSError(domain: "HealthKit", code: 2, userInfo: [NSLocalizedDescriptionKey: "Mindfulness session type not available"]))
            return
        }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: mindfulType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
            if let error = error {
                print("Error fetching mindfulness sessions: \(error.localizedDescription)")
                completion(nil, error)
            } else if let samples = results as? [HKCategorySample] {
                print("Fetched \(samples.count) mindfulness sessions for date \(date)")
                completion(samples, nil)
            } else {
                completion(nil, nil)
            }
        }
        
        healthStore.execute(query)
    }
    
    // MARK: - 특정 달의 Mindful Session 데이터 조회
    func fetchMonthlyMindfulSessions(for month: Date, completion: @escaping ([HKCategorySample]?, Error?) -> Void) {
        guard let mindfulType = HKCategoryType.categoryType(forIdentifier: .mindfulSession) else {
            completion(nil, NSError(domain: "HealthKit", code: 2, userInfo: [NSLocalizedDescriptionKey: "Mindfulness session type not available"]))
            return
        }
        
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month))!
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfMonth, end: endOfMonth, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: mindfulType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
            if let error = error {
                print("Error fetching monthly mindfulness sessions: \(error.localizedDescription)")
                completion(nil, error)
            } else if let samples = results as? [HKCategorySample] {
                print("Fetched \(samples.count) mindfulness sessions for month \(month)")
                completion(samples, nil)
            } else {
                completion(nil, nil)
            }
        }
        
        healthStore.execute(query)
    }
}
