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
    
    let healthKitService = HealthKitManager()
    
    var body: some View {
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
            
            // 오류 메시지 표시
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
            
            Button(action: {
                fetchTodayHRVData()
                fetchThisMonthHRVData()
            }, label: {
                Text("Fetch Data")
                    
            })
        }
        .padding()
        
    }
    
    // 오늘의 HRV 데이터를 가져오는 메서드
    private func fetchTodayHRVData() {
        healthKitService.fetchDailyHRV(for: Date()) { samples, error in
            if let error = error {
                errorMessage = "Error fetching daily HRV data: \(error.localizedDescription)"
            } else if let samples = samples {
                dailyHRVData = samples.map { sample in
                    let sdnnValue = sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli))
                    return String(format: "SDNN: %.2f ms at %@", sdnnValue, sample.startDate.description)
                }
            } else {
                errorMessage = "No daily HRV data available."
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
                } else if let samples = samples {
                    monthlyHRVData = samples.map { sample in
                        let sdnnValue = sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli))
                        return String(format: "SDNN: %.2f ms at %@", sdnnValue, sample.startDate.description)
                    }
                } else {
                    errorMessage = "No monthly HRV data available."
                }
            }
        }
    }
}

#Preview {
    HealthKitTestView()
}
