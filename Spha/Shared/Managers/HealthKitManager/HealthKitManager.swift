//
//  HealthKitManager.swift
//  Spha
//
//  Created by 지영 on 11/12/24.
//

import Foundation
import HealthKit

protocol HealthKitInterface {
    func fetchDailyHRV(for date: Date, completion: @escaping ([HKQuantitySample]?, Error?) -> Void) // 일간 HRV 데이터 요청
    func fetchMonthlyHRV(for month: Date, completion: @escaping ([HKQuantitySample]?, Error?) -> Void) // 월간 HRV 데이터 요청
}

class HealthKitManager: HealthKitInterface {

    let healthStore = HKHealthStore()

    // 읽기 및 쓰기 권한 설정 - HRV 데이터를 위한 권한 추가
    let read = Set([HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!])
    let share = Set([HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!])
    
    
    // 권한 요청 메소드
    func requestAuthorization() {
        if !HKHealthStore.isHealthDataAvailable() {return} // HealthKit 사용 가능인지 체크
        self.healthStore.requestAuthorization(toShare: share, read: read) { success, error in
            if error != nil {
                print(error.debugDescription)
            }else{
                if success {
                    print("권한이 허락되었습니다")
                }else{
                    print("권한이 없습니다")
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
}
