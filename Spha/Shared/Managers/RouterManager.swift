//
//  RouterManager.swift
//  Spha
//
//  Created by 추서연 on 11/13/24.
//


import SwiftUI

class RouterManager: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
    
    @ViewBuilder func view(for route: SphaView) -> some View {
        switch route {
        case .mainView:
            //MainView()
            ContentView()
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
        path.append(SphaView.mainView)
    }
}

enum SphaView: Hashable {
    case mainView
}
