//
//  AppDelegate.swift
//  Spha
//
//  Created by LDW on 11/14/24.
//

import UIKit
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var healthKitManager = HealthKitManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 알림 권한 요청
        healthKitManager.requestNotificationAuthorization()
        // HealthKit 권한 요청
        healthKitManager.requestAuthorization { _ in        }
        
        // MARK: - UNUserNotificationCenterDelegate 설정 [테스트용!]
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        healthKitManager.didUpdateHRVData()
        completionHandler(.newData)
    }
    
    // MARK: - 포그라운드에서 알림을 수신했을 때 표시하도록 설정 [테스트용]
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 알림을 배너로 표시
        completionHandler([.banner, .sound, .badge])
    }
}
