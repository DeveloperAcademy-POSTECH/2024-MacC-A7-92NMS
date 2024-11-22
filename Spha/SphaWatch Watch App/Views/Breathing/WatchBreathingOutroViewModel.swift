//
//  WatchBreathingOutroViewModel.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/22/24.
//

import Foundation
import Combine

class WatchBreathingOutroViewModel: ObservableObject {
    @Published var statusMessage: String = ""
    @Published var dailySessions: [String] = []
    
    private let mindfulSessionManager = MindfulSessionManager()
    
    // MARK: - 오늘의 Mindful Session 조회 후 세션 개수 +1
    func fetchTodaySessions() {
        mindfulSessionManager.fetchMindfulSessions(for: Date()) { sessions, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.statusMessage = "Error fetching today's sessions: \(error.localizedDescription)"
                } else if let sessions = sessions {
                    let sessionCount = sessions.count + 1
                    self.dailySessions = sessions.map { session in
                        "Start: \(session.startDate), End: \(session.endDate)"
                    }
                    self.statusMessage = "Today's sessions count: \(sessionCount)"
                } else {
                    self.dailySessions = []
                    self.statusMessage = "No sessions found for today."
                }
            }
        }
    }
}
