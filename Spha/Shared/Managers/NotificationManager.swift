//
//  NotificationManager.swift
//  Spha
//
//  Created by 지영 on 11/25/24.
//

import Foundation
import UserNotifications
#if os(watchOS)
import WatchKit
#endif

protocol NotificationInterface {
    func setupNotifications(completion: @escaping (Bool, Error?) -> Void)
    func sendBreathingAlert()
}

class NotificationManager: NSObject, NotificationInterface {
    static let shared = NotificationManager()
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private override init() {
        super.init()
        // setupNotifications()
    }

    func setupNotifications(completion: @escaping (Bool, Error?) -> Void) {
        let openAppAction = UNNotificationAction(
            identifier: "OPEN_APP",
            //title: "마음 청소하러 가기",
            title: String(localized: "notification_open_action"),
            options: .foreground
        )
        
        let cancelAction = UNNotificationAction(
            identifier: "CANCEL",
            title: String(localized: "notification_cancel_action"),
            options: .destructive
        )
        
        // 카테고리 설정
        let hrvCategory = UNNotificationCategory(
            identifier: "HRV_ALERT",
            actions: [openAppAction, cancelAction],
            intentIdentifiers: [],
            options: []
        )
        
        // 카테고리 등록
        notificationCenter.setNotificationCategories([hrvCategory])
        
        // 알림 권한 요청
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Watch 알림 권한 획득")
            } else if let error = error{
                print("Error: \(error.localizedDescription))")
            }
            completion(granted, error)
        }
        
        // 델리게이트 설정
        notificationCenter.delegate = self
    }
    
    func sendBreathingAlert() {
        let content = UNMutableNotificationContent()
        content.title = "Spha"
        content.body = String(localized: "notification_breathing_alert")
        content.sound = .default
        content.categoryIdentifier = "HRV_ALERT"  // 카테고리 지정
        
        #if os(watchOS)
        WKInterfaceDevice.current().play(.notification)
        #endif
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        notificationCenter.add(request)
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        #if os(watchOS)
        // Handle watchOS-specific action
        switch response.actionIdentifier {
        case "OPEN_APP":
            // Watch-specific navigation or logic
            NotificationCenter.default.post(name: Notification.Name("goToBreathingNotification"), object: nil)
        default:
            break
        }
        #else
        // Handle iOS/macOS action
        switch response.actionIdentifier {
        case "OPEN_APP":
            NotificationCenter.default.post(name: Notification.Name("goToBreathingNotification"), object: nil)
        default:
            break
        }
        #endif
        
        completionHandler()
    }
}

