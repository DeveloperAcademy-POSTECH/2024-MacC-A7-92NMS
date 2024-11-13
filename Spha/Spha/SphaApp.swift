//
//  SphaApp.swift
//  Spha
//
//  Created by 지영 on 11/12/24.
//

import SwiftUI

@main
struct SphaApp: App {
    
    let healthKitManager = HealthKitManager()
    
    init() {
        configuire()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            // HealthKitTestView()
        }
    }

    func configuire() {
        healthKitManager.requestAuthorization()
    }
}
