//
//  WatchBreathingOutroViewModel.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/22/24.
//

import Foundation
import Combine

class WatchBreathingOutroViewModel: ObservableObject {
    @Published var statusMessage: String? = nil
    private let mindfulSessionManager = MindfulSessionManager()

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
}
