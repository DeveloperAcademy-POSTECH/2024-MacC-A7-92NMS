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

private struct DailyStressTrendView: View {
    
    var body: some View {
        Text("일일 스트레스 추이")
    }
}

#Preview {
    DailyStatisticsView()
}
