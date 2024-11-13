//
//  HealthKitManager.swift
//  Spha
//
//  Created by 지영 on 11/12/24.
//

import Foundation
import HealthKit

protocol HealthKitInterface {
    func checkDevice() // 건강 데이터를 사용할 수 있는 디바이스인지 확인
    func requestAuthorization() // 접근 권한 요청
    func fetchDailyHRV() // 일간 HRV 데이터 요청
    func fetchMonthlyHRV() // 월간 HRV 데이터 요청
}


class HealthKitService: HealthKitInterface {

    let healthStore = HKHealthStore()

    // 읽기 및 쓰기 권한 설정 - HRV 데이터를 위한 권한 추가
    let read = Set([HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!])
    let share = Set([HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!])

    func checkDevice() {
        
    }
    
    func requestAuthorization() {
        
    }
    
    func fetchDailyHRV() {
        
    }
    
    func fetchMonthlyHRV() {
        
    }

}
