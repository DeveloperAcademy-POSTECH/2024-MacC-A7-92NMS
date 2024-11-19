//
//  WatchRouterManager.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/19/24.
//

import SwiftUI

class WatchRouterManager: ObservableObject {
    @Published var path: [SphaView] = []
    @Published var selectedTab: Int = 0  // 탭 상태를 관리
    
    @ViewBuilder func view(for route: SphaView) -> some View {
        switch route {
        case .watchMainView:
            WatchMainView()
        case .watchbreathingSelectionView:
            WatchBreathingSelectionView()
        case .watchbreathingMainView:
            WatchBreathingMainView()
        }
    }
    
    func push(view: SphaView) {
        path.append(view)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func backToWatchMain() {
        path = [.watchMainView]
        selectedTab = 0  // 첫 번째 탭으로 이동
    }
}

enum SphaView: Hashable {
    case watchMainView
    case watchbreathingSelectionView
    case watchbreathingMainView
}
