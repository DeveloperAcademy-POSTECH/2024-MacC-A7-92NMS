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
    static let goToBreathingNotification = Notification.Name("goToBreathingNotification")
    
    init() {
        // Notification 구독
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(navigateToBreathingMainView),
            name: RouterManager.goToBreathingNotification,
            object: nil
        )
    }
    
    @MainActor
    @ViewBuilder func view(for route: SphaView) -> some View {
        switch route {
        case .mainView:
            MainView()
                .navigationBarHidden(true) // 네비게이션 바 숨기기
        case .breathingMainView:
            let breathingViewModel = BreathingMainViewModel()
            BreathingMainView(breathManager: breathingViewModel)
        case .breathingOutroView:
            BreathingOutroView()
        case .onboardingStartView:
            OnboardingStartView()
                .navigationBarHidden(true)
        case .onboardingView:
            let hrvService = HealthKitManager()
            let mindfulService = MindfulSessionManager()
            OnboardingContainerView(hrvService: hrvService, mindfulService: mindfulService, notificationManager: NotificationManager.shared)
                .navigationBarHidden(true)
        case .mainInfoView:
            MainInfoView()
                .navigationBarHidden(true)
        case .dailyStatisticsView:
            DailyStatisticsView()
                .navigationBarHidden(true)
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
    
    // 알림을 눌렀을 때 breathingMainView로 이동
    @objc private func navigateToBreathingMainView() {
        DispatchQueue.main.async { [weak self] in
            self?.path = NavigationPath()
            self?.path.append(SphaView.breathingMainView)
        }
    }
}

enum SphaView: Hashable {
    case mainView
    case breathingMainView
    case breathingOutroView
    case onboardingStartView
    case onboardingView
    case mainInfoView
    case dailyStatisticsView
}

