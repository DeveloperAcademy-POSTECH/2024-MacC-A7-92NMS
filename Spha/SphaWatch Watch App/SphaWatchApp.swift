
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
}
