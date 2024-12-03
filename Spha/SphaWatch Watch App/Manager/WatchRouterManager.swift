//
//  WatchRouterManager.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/19/24.
//

import SwiftUI

class WatchRouterManager: ObservableObject {
    
    @Published var path: [SphaView] = []
    static let goToBreathingNotification = Notification.Name("goToBreathingNotification")
    
    init() {
        // Notification 구독
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(navigateToBreathingMainView),
            name: WatchRouterManager.goToBreathingNotification,
            object: nil
        )
    }
    
    @ViewBuilder func view(for route: SphaView) -> some View {
        switch route {
        case .watchMainView:
            WatchMainView()
        case .watchbreathingSelectionView:
            WatchBreathingSelectionView()
        case .watchbreathingMainView:
            WatchBreathingMainView()
        case .watchbreathingOutroView:
            WatchBreathingOutroView()
        }
    }
    
    func push(view: SphaView) {
        path.append(view)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func backToWatchMain() {
        path.removeAll()
        path.append(.watchMainView)
    }
    
    // 알림을 눌렀을 때 breathingMainView로 이동
    @objc private func navigateToBreathingMainView() {
        DispatchQueue.main.async { [weak self] in
            self?.path = []
            self?.path.append(SphaView.watchbreathingMainView)
        }
    }
}

enum SphaView: Hashable {
    case watchMainView
    case watchbreathingSelectionView
    case watchbreathingMainView
    case watchbreathingOutroView
}
