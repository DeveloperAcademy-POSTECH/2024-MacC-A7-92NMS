//
//  SphaApp.swift
//  Spha
//
//  Created by 지영 on 11/12/24.
//

import SwiftUI

@main
struct SphaApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var router: RouterManager = RouterManager()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for: .default)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path){
                OnboardingStartView()
                    .navigationDestination(for: SphaView.self){ sphaView in
                        router.view(for: sphaView)
                    }
            }
            .tint(.white)
            .foregroundStyle(.white)
            .environmentObject(router)
        }
    }
    
}
