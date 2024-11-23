//
//  BreathingOutroViewModel.swift
//  Spha
//
//  Created by 추서연 on 11/24/24.
//

import SwiftUI

class BreathingOutroViewModel: ObservableObject {
    @Published var opacity: Double = 1.0
    @Published var statusMessage: String? = nil

    private let mindfulSessionManager = MindfulSessionManager()

    func fadeOutAnimation(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeOut(duration: 1.0)) {
                self.opacity = 0.0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completion()
            }
        }
    }

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
