//
//  AppDelegate.swift
//  Spha
//
//  Created by LDW on 11/14/24.
//

import UIKit
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var healthKitManager = HealthKitManager.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if !isFirstLaunch() {
            // 첫 실행 시 권한 요청
            healthKitManager.requestAuthorization { _, _ in
                print("HealthKit 권한 요청 완료")
            }
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
                if success {
                    print("Notification 권한 요청 완료")
                }
            }
        } else {
            print("앱 첫 실행임 - 권한 요청 생략")
        }
        
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
//    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        healthKitManager.didUpdateHRVData()
//        completionHandler(.newData)
//    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "OPEN_APP":
            NotificationCenter.default.post(name: RouterManager.goToBreathingNotification, object: nil)
        default:
            break
        }

        completionHandler()
    }
    
    // 앱 첫 실행 여부 확인
    private func isFirstLaunch() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "hasLaunchedBefore") {
            return false // 이미 실행된 적 있음
        } else {
            // defaults.set(true, forKey: "hasLaunchedBefore")
            return true // 첫 실행
        }
    }
}
