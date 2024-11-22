//
//  WatchRouterManager.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/19/24.
//

import SwiftUI

class WatchRouterManager: ObservableObject {
    
    @Published var path: [SphaView] = []
    
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
}

enum SphaView: Hashable {
    case watchMainView
    case watchbreathingSelectionView
    case watchbreathingMainView
    case watchbreathingOutroView
}
