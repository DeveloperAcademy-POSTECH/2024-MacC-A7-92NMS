//
//  WatchBreathingOutroViewModel.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/22/24.
//

import Foundation
import Combine
import SwiftUI

class WatchBreathingOutroViewModel: ObservableObject {
    @Published var statusMessage: String? = nil
    @Published var opacity: Double = 1.0
    
    private let mindfulSessionManager = MindfulSessionManager()

    //MindfulSession 세션 저장
    func recordTestMindfulSession() {
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .minute, value: 10, to: startDate)!

        mindfulSessionManager.recordMindfulSession(startDate: startDate, endDate: endDate) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.statusMessage = "Test Mindful Session Recorded Successfully!"
                } else if let error = error {
                    self.statusMessage = "Error Recording Session: \(error.localizedDescription)"
                } else {
                    self.statusMessage = "Failed to record session."
                }
            }
        }
    }

    func startFadeOutProcess(router: WatchRouterManager) {
        recordTestMindfulSession()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut(duration: 1.0)) {
                self.opacity = 0.0  // Fade out
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                router.backToWatchMain()
                router.pop()
            }
        }
    }
}
