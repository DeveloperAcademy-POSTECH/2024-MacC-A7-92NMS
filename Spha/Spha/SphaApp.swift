//
//  SphaApp.swift
//  Spha
//
//  Created by 지영 on 11/12/24.
//

import SwiftUI

@main
struct SphaApp: App {
    @StateObject var router: RouterManager = RouterManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path){
                MainView()
                    .navigationDestination(for: SphaView.self){ sphaView in
                        router.view(for: sphaView)
                    }
            }
            .tint(.black)
            .environmentObject(router)
        }
    }
}
