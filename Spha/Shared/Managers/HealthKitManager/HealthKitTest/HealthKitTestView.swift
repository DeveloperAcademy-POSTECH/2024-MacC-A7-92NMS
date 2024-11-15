//
//  HealthKitTestView.swift
//  Spha
//
//  Created by LDW on 11/13/24.
//
import SwiftUI
import HealthKit

struct HealthKitTestView: View {
    
    @State private var dailyHRVData: [String] = [] // 오늘의 HRV 데이터를 저장
    @State private var monthlyHRVData: [String] = [] // 이번 달의 HRV 데이터를 저장
    @State private var errorMessage: String? = nil // 오류 메시지
    @State private var successMessage: String? = nil // 성공 메시지
    
    let healthKitService = HealthKitManager()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("HRV Data Test")
                    .font(.title)
                    .padding()
                
                // 오늘의 HRV 데이터 섹션
                VStack(alignment: .leading, spacing: 10) {
                    Text("Today's HRV Data")
                        .font(.headline)
                    
                    if dailyHRVData.isEmpty {
                        Text("No data available or error occurred.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(dailyHRVData, id: \.self) { data in
                            Text(data)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                // 이번 달의 HRV 데이터 섹션
                VStack(alignment: .leading, spacing: 10) {
                    Text("This Month's HRV Data")
                        .font(.headline)
                    
                    if monthlyHRVData.isEmpty {
                        Text("No data available or error occurred.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(monthlyHRVData, id: \.self) { data in
                            Text(data)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                // 성공 메시지 표시
                if let successMessage = successMessage {
                    Text(successMessage)
                        .foregroundColor(.green)
                        .padding()
                }
                
                // 오류 메시지 표시
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
                
                // 데이터 가져오기 버튼
                Button(action: {
                    fetchTodayHRVData()
                    fetchThisMonthHRVData()
                }, label: {
                    Text("Fetch Data")
                })
                
                // HRV 데이터 기록 버튼
                Button(action: {
                    recordTestHRVData()
                }, label: {
                    Text("Record Test HRV Data")
                })
            }
            .padding()
        }
    }
    
    // 오늘의 HRV 데이터를 가져오는 메서드
    private func fetchTodayHRVData() {
        healthKitService.fetchDailyHRV(for: Date()) { samples, error in
            if let error = error {
                errorMessage = "Error fetching daily HRV data: \(error.localizedDescription)"
                successMessage = nil
            } else if let samples = samples {
                dailyHRVData = samples.map { sample in
                    let sdnnValue = sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli))
                    return String(format: "SDNN: %.2f ms at %@", sdnnValue, sample.startDate.description)
                }
                successMessage = "Successfully fetched today's HRV data."
                errorMessage = nil
            } else {
                errorMessage = "No daily HRV data available."
                successMessage = nil
            }
        }
    }
    
    // 이번 달의 HRV 데이터를 가져오는 메서드
    private func fetchThisMonthHRVData() {
        let calendar = Calendar.current
        if let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date())) {
            healthKitService.fetchMonthlyHRV(for: startOfMonth) { samples, error in
                if let error = error {
                    errorMessage = "Error fetching monthly HRV data: \(error.localizedDescription)"
                    successMessage = nil
                } else if let samples = samples {
                    monthlyHRVData = samples.map { sample in
                        let sdnnValue = sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli))
                        return String(format: "SDNN: %.2f ms at %@", sdnnValue, sample.startDate.description)
                    }
                    successMessage = "Successfully fetched this month's HRV data."
                    errorMessage = nil
                } else {
                    errorMessage = "No monthly HRV data available."
                    successMessage = nil
                }
            }
        }
    }
    
    // 테스트용 HRV 데이터를 기록하는 메서드
    private func recordTestHRVData() {
        healthKitService.recordTestHRV { success, error in
            if success {
                successMessage = "Test HRV data recorded successfully."
                errorMessage = nil
            } else if let error = error {
                errorMessage = "Error recording test HRV data: \(error.localizedDescription)"
                successMessage = nil
            }
        }
    }
}

#Preview {
    HealthKitTestView()
}
