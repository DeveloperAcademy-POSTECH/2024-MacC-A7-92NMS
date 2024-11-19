//
//  MindfulSessionTestView.swift
//  Spha
//
//  Created by LDW on 11/19/24.
//

import SwiftUI
import HealthKit

struct MindfulSessionTestView: View {
    @State private var dailySessions: [String] = [] // 특정 날짜의 Mindful Session 데이터
    @State private var monthlySessions: [String] = [] // 특정 달의 Mindful Session 데이터
    @State private var statusMessage: String? = nil // 상태 메시지
    @State private var isAuthorized: Bool = false // HealthKit 권한 상태

    private let mindfulSessionManager = MindfulSessionManager() // MindfulSessionManager 인스턴스

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Mindful Session Test")
                    .font(.title)
                    .padding()
                
                // HealthKit 권한 상태 표시
                if isAuthorized {
                    Text("HealthKit Access: Granted")
                        .foregroundColor(.green)
                } else {
                    Text("HealthKit Access: Not Granted")
                        .foregroundColor(.red)
                }
                
                // 오늘의 Mindful Session 데이터 섹션
                VStack(alignment: .leading, spacing: 10) {
                    Text("Today's Sessions")
                        .font(.headline)
                    if dailySessions.isEmpty {
                        Text("No data available.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(dailySessions, id: \.self) { session in
                            Text(session)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                // 이번 달의 Mindful Session 데이터 섹션
                VStack(alignment: .leading, spacing: 10) {
                    Text("This Month's Sessions")
                        .font(.headline)
                    if monthlySessions.isEmpty {
                        Text("No data available.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(monthlySessions, id: \.self) { session in
                            Text(session)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                // 상태 메시지
                if let statusMessage = statusMessage {
                    Text(statusMessage)
                        .foregroundColor(.blue)
                        .padding()
                }
                
                Spacer()
                
                // 버튼들
                VStack(spacing: 15) {
                    Button("Request Authorization") {
                        requestAuthorization()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Record Mindful Session") {
                        recordTestMindfulSession()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Fetch Today's Sessions") {
                        fetchTodaySessions()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Fetch This Month's Sessions") {
                        fetchThisMonthSessions()
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
            .onAppear {
                checkAuthorizationStatus()
            }
        }
    }

    // MARK: - 권한 요청
    private func requestAuthorization() {
        mindfulSessionManager.requestAuthorization()
        checkAuthorizationStatus()
    }

    // MARK: - 권한 상태 확인
    private func checkAuthorizationStatus() {
        guard let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession) else { return }
        mindfulSessionManager.healthStore.getRequestStatusForAuthorization(toShare: [mindfulType], read: [mindfulType]) { status, error in
            DispatchQueue.main.async {
                if status == .unnecessary {
                    isAuthorized = true
                } else {
                    isAuthorized = false
                }
            }
        }
    }

    // MARK: - Mindful Session 기록 (테스트 데이터)
    private func recordTestMindfulSession() {
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .minute, value: 10, to: startDate)!

        mindfulSessionManager.recordMindfulSession(startDate: startDate, endDate: endDate) { success, error in
            DispatchQueue.main.async {
                if success {
                    statusMessage = "Test Mindful Session Recorded Successfully!"
                } else if let error = error {
                    statusMessage = "Error Recording Session: \(error.localizedDescription)"
                } else {
                    statusMessage = "Failed to record session."
                }
            }
        }
    }

    // MARK: - 오늘의 Mindful Session 조회
    private func fetchTodaySessions() {
        mindfulSessionManager.fetchMindfulSessions(for: Date()) { sessions, error in
            DispatchQueue.main.async {
                if let error = error {
                    statusMessage = "Error fetching today's sessions: \(error.localizedDescription)"
                } else if let sessions = sessions {
                    dailySessions = sessions.map { session in
                        "Start: \(session.startDate), End: \(session.endDate)"
                    }
                } else {
                    dailySessions = []
                    statusMessage = "No sessions found for today."
                }
            }
        }
    }

    // MARK: - 이번 달의 Mindful Session 조회
    private func fetchThisMonthSessions() {
        let calendar = Calendar.current
        if let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date())) {
            mindfulSessionManager.fetchMonthlyMindfulSessions(for: startOfMonth) { sessions, error in
                DispatchQueue.main.async {
                    if let error = error {
                        statusMessage = "Error fetching this month's sessions: \(error.localizedDescription)"
                    } else if let sessions = sessions {
                        monthlySessions = sessions.map { session in
                            "Start: \(session.startDate), End: \(session.endDate)"
                        }
                    } else {
                        monthlySessions = []
                        statusMessage = "No sessions found for this month."
                    }
                }
            }
        }
    }
}

#Preview {
    MindfulSessionTestView()
}
