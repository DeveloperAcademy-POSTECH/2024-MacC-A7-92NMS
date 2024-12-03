
//
//  SphaWatchApp.swift
//  SphaWatch Watch App
//
//  Created by 지영 on 11/12/24.
//

import SwiftUI

@main
struct SphaWatch_Watch_AppApp: App {
    @StateObject var router: WatchRouterManager = WatchRouterManager()
    private let mindfulSessionManager = MindfulSessionManager()
    private let healthKitManager = HealthKitManager()
    
    init() {
            // 앱 시작시 권한 요청
            requestAuthorization()
        }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                // 초기 화면으로 WatchMainView를 표시
                WatchMainView()
                    .navigationDestination(for: SphaView.self) { sphaView in
                        // WatchRouterManager를 사용하여 해당 view를 반환
                        router.view(for: sphaView)
                    }
            }
            .environmentObject(router)
        }
    }
    private func requestAuthorization() {
        mindfulSessionManager.requestAuthorization{ _ in }
        healthKitManager.requestAuthorization { _, _ in }
    }
}
