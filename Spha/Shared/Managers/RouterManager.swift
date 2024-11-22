//
//  RouterManager.swift
//  Spha
//
//  Created by 추서연 on 11/13/24.
//


import SwiftUI

class RouterManager: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()

    // 추가: 상태 업데이트를 위한 Notification 이름
    static let backToMainNotification = Notification.Name("backToMainNotification")
    
    @ViewBuilder func view(for route: SphaView) -> some View {
        switch route {
        case .mainView:
            MainView()
        case .breathingMainView:
            let breathingViewModel = BreathingMainViewModel()
            BreathingMainView(breathManager: breathingViewModel)
        case .breathingOutroView:
            BreathingOutroView()
        case .onboardingStartView:
            OnboardingStartView()
        case .onboardingView:
            OnboardingContainerView()
        }
    }
    
    func push(view: SphaView) {
        path.append(view)
    }
    
    func pop() {
        path.removeLast()
    }

    func backToMain() {
        self.path = NavigationPath()
        // 상태 초기화를 알리는 Notification 전송
        NotificationCenter.default.post(name: RouterManager.backToMainNotification, object: nil)
        path.append(SphaView.mainView)
    }
}

enum SphaView: Hashable {
    case mainView
    case breathingMainView
    case breathingOutroView
    case onboardingStartView
    case onboardingView
}

