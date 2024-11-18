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

#Preview {
    DailyStatisticsView()
}
