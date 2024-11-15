//
//  NotificationManager.swift
//  SphaWatch Watch App
//
//  Created by 지영 on 11/12/24.
//

import WatchKit
import UserNotifications

protocol NotificationInterface {
    func handleStress()
}

class NotificationManager: NSObject, NotificationInterface {
    private let notificationCenter = UNUserNotificationCenter.current()
    
    override init() {
        super.init()
        setupNotifications()
    }
    
    private func setupNotifications() {
        let openAppAction = UNNotificationAction(
            identifier: "OPEN_APP",
            title: "마음 청소하러 가기",
            options: .foreground
        )
        
        let cancelAction = UNNotificationAction(
            identifier: "CANCEL",
            title: "지금 안함",
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
        }
        
        // 델리게이트 설정
        notificationCenter.delegate = self
    }
    
    func handleStress() {
        let content = UNMutableNotificationContent()
        content.title = "Spha"
        content.body = "마음이 더러워 졌어요\n청소하러 가요"
        content.sound = .default
        content.categoryIdentifier = "HRV_ALERT"  // 카테고리 지정
        
        WKInterfaceDevice.current().play(.notification)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        notificationCenter.add(request)
    }
}

// 알림 액션 처리를 위한 델리게이트 확장
extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        switch response.actionIdentifier {
        case "OPEN_APP":
            print("앱 실행")
            // TODO: 앱 실행 관련 추가 로직 구현
        case "CANCEL":
            print("알림 취소")
        default:
            break
        }
        
        completionHandler()
    }
    
    // 앱이 포그라운드 상태일 때 알림을 표시하기 위한 메서드
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}
