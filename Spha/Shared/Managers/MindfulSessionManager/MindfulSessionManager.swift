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
    func deleteDailyMindfulSessions(for date: Date, completion: @escaping (Bool, Error?) -> Void)
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

extension MindfulSessionManager {
    func deleteDailyMindfulSessions(for date: Date, completion: @escaping (Bool, Error?) -> Void) {
        guard let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession) else {
            print("Error: MindfulSession 데이터 타입을 찾을 수 없습니다.")
            completion(false, NSError(domain: "HealthKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "MindfulSession 데이터 타입을 찾을 수 없습니다."]))
            return
        }

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)

        // Fetching samples to delete
        let query = HKSampleQuery(sampleType: mindfulType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] _, results, error in
            guard let self = self else {
                completion(false, nil)
                return
            }

            if let error = error {
                print("Error fetching mindfulness sessions: \(error.localizedDescription)")
                completion(false, error)
                return
            }

            guard let sessions = results as? [HKSample], !sessions.isEmpty else {
                print("No mindfulness sessions found to delete for date \(date).")
                completion(false, nil)
                return
            }

            print("Fetched \(sessions.count) mindfulness sessions to delete.")

            // Log 삭제하려는 데이터
            for session in sessions {
                print("Session to delete: \(session)")
            }

            // Deleting fetched samples
            self.healthStore.delete(sessions) { success, deleteError in
                if let deleteError = deleteError {
                    print("Error deleting mindfulness sessions: \(deleteError.localizedDescription)")
                    completion(false, deleteError)
                } else if success {
                    print("Successfully deleted \(sessions.count) mindfulness sessions.")
                    completion(true, nil)
                } else {
                    print("Failed to delete mindfulness sessions.")
                    completion(false, nil)
                }
            }
        }

        healthStore.execute(query)
    }
}
