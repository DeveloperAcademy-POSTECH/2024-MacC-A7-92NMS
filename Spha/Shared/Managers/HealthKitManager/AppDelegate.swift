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

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        healthKitManager.didUpdateHRVData()
        completionHandler(.newData)
    }
}
