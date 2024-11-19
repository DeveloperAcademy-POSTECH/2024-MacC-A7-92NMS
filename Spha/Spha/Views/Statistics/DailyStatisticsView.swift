//
//  DailyStatisticsView.swift
//  Spha
//
//  Created by 지영 on 11/15/24.
//

import SwiftUI
import Charts

struct DailyStatisticsView: View {
    @StateObject private var viewModel = WeeklyCalendarHeaderViewModel()
    @State private var selectedDate: Date? = nil
    
    var body: some View {
        WeeklyCalendarHeaderView(viewModel: viewModel)
        DailyChartsView()
        Spacer()
    }
}


private struct WeeklyCalendarHeaderView: View {
    @ObservedObject var viewModel: WeeklyCalendarHeaderViewModel
    
    var body: some View {
        TabView(selection: $viewModel.selectedDate) {
            ForEach(viewModel.weeks, id: \.self) { week in
                HStack(spacing: 32) {
                    ForEach(week, id: \.self) { date in
                        DayItemView(
                            date: date,
                            isSelected: viewModel.calendar.isDate(date, inSameDayAs: viewModel.currentDate),
                            onTap: {
                                viewModel.handleDateTap(date)
                            }
                        )
                    }
                }
                .tag(week[0])
                .onAppear {
                    if week == viewModel.weeks.first {
                        viewModel.loadPreviousWeek()
                    }
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(height: 56)
        .padding(.horizontal, 24)
        .onAppear {
            viewModel.selectedDate = viewModel.weeks.last![0]
        }
    }
}


private struct DayItemView: View {
    let date: Date
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Text(date.dayString)
                .font(.caption)
                .foregroundColor(date > Date() ? .gray.opacity(0.3) :
                                    isSelected ? .white : .gray)
            
            Text(date.dayNumber)
                .foregroundColor(date > Date() ? .gray.opacity(0.3) :
                                    isSelected ? .white : .primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(isSelected ? Color.gray : Color.clear)
        .clipShape(Capsule())
        .onTapGesture(perform: onTap)
    }
}

// MARK: - 일일 통계 차트
private struct DailyChartsView: View {
    var body: some View {
        VStack {
            Text("일일 마음 청소 통계")
            DailyPieChartView()
            DailyStressTrendView()
        }
    }
}

private struct DailyPieChartView: View {
    struct Data: Hashable {
        let color: Color
        let count: Int
    }
    
    var data = [
        Data(color: .black, count: 3),
        Data(color: .gray, count: 1)
    ]
    
    var body: some View {
        Chart(data, id: \.self) { element in
            SectorMark(
                angle: .value("Usage", element.count),
                innerRadius: .ratio(0.98),
                angularInset: 1
            )
            .foregroundStyle(element.color)
        }
        .padding(.horizontal, 124)
    }
}

// MARK: - 일일 스트레스 추이 그래프
private struct DailyStressTrendView: View {
    var body: some View {
        Chart {
            /// y축 수평 기준선
            ForEach(StressLevel.allCases, id: \.self) { level in
                RuleMark(
                    y: .value("Level", level.numberValue)
                )
                .foregroundStyle(.gray.opacity(0.3))
            }
            
            /// x축 수직 시간 기준선
            ForEach(Array(stride(from: 0, through: 24, by: 6)), id: \.self) { hour in
                RuleMark(
                    x: .value("Hour", Double(hour))
                )
                .foregroundStyle(.gray.opacity(0.3))
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
            }
        }
        .chartYScale(domain: -0.5...3)
        .chartXScale(domain: -0.5...26.5)
        /// y축 설정
        .chartYAxis {
            AxisMarks(position: .leading,
                      values: StressLevel.allCases.map { Double($0.numberValue) }) { value in
                AxisValueLabel {
                    Text(StressLevel.allCases[value.index].title)
                        .font(.system(size: 12))
                }
            }
        }
        /// x축 설정
        .chartXAxis {
            AxisMarks(values: .stride(by: 6)) { value in
                AxisValueLabel(anchor: .center) {
                    Text(String(format: "%02d:00", value.index * 6))
                        .font(.system(size: 8))
                }
            }
        }
        .frame(height: 200)
        .padding()
    }
}

#Preview {
    DailyStatisticsView()
}
