//
//  AppDelegate.swift
//  Spha
//
//  Created by LDW on 11/14/24.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var healthKitManager = HealthKitManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        healthKitManager.requestAuthorization() // 권한 요청
        healthKitManager.monitorHRVUpdates()    // HRV 데이터 업데이트 관찰 시작
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        healthKitManager.didUpdateHRVData()
        completionHandler(.newData)
    }
}
