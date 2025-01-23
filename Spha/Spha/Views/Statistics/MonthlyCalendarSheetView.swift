//
//  MonthlyCalendarSheetView.swift
//  Spha
//
//  Created by 지영 on 12/16/24.
//

import SwiftUI

struct MonthlyCalendarSheetView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: DailyStatisticsViewModel
    @Binding var selectedDate: Date
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 0) {
                    ForEach(Date.getWeekdayHeadersStartingMonday(), id: \.self) { weekday in
                        Text(weekday)
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .frame(height: 30)
                    }
                }
                .padding(.horizontal)
                .background(Color.black)
                
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.getCalendarMonths(), id: \.self) { monthDate in
                                MonthView(
                                    date: monthDate,
                                    viewModel: viewModel,
                                    selectedDate: $selectedDate,
                                    dismiss: dismiss
                                )
                                .id(monthDate)
                            }
                        }
                        .padding(.horizontal, 10)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation {
                                    proxy.scrollTo(viewModel.currentMonth, anchor: .center)  // 현재 날짜로 스크롤
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Rectangle()
                        .frame(width: 45, height: 4)
                        .padding(.bottom, 32)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(NSLocalizedString("confirm", comment: "확인")) {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
            .toolbarBackground(.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .background(Color.black)
        }
        .preferredColorScheme(.dark)
        .onAppear {
                    viewModel.loadMonthData(for: viewModel.currentMonth)
                }
    }
}

struct MonthView: View {
    let date: Date
    @ObservedObject var viewModel: DailyStatisticsViewModel
    @Binding var selectedDate: Date
    let dismiss: DismissAction
    
    var body: some View {
           LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7),
               spacing: 0
           ) {
               ForEach(viewModel.getDaysInMonthStartingMonday(for: date), id: \.offset) { index, date in
                   if let date = date {
                       VStack(spacing: 0) {
                           VStack {
                               if date.dayNumber == "1" {
                                   Text(date.monthString)
                                       .font(.title3).bold()
                                       .foregroundColor(.white)
                               }
                           }
                           .frame(height: 22)
                           .padding(.bottom, 20)  // monthString과 첫 주 사이 간격 20 유지
                           
                           MonthlyDayView(
                               date: date,
                               isSelected: viewModel.calendar.isDate(date, inSameDayAs: selectedDate),
                               isToday: viewModel.calendar.isDate(date, inSameDayAs: Date()),
                               viewModel: viewModel,
                               onTap: {
                                   if date <= Date() {
                                       selectedDate = date
                                       dismiss()
                                   }
                               }
                           )
                       }
                   } else {
                       VStack(spacing: 0) {
                           Color.clear
                               .frame(height: 22)
                               .padding(.bottom, 20)  // 빈 셀에도 동일한 간격 적용
                           Color.clear.frame(width: 44, height: 44)
                       }
                   }
               }
           }
           .padding(.bottom, 36)
       }
   }

struct MonthlyDayView: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    @ObservedObject var viewModel: DailyStatisticsViewModel
    let onTap: () -> Void
    
    var body: some View {
        ZStack {
            Circle()
                .fill(viewModel.getCircleFillColor(for: date))
            
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 3.0)
            
            if date <= Date() {  // 미래 날짜는 제외
                Circle()
                    .trim(from: 0.0, to: viewModel.getBreathingRatio(for: date))
                    .stroke(style: StrokeStyle(lineWidth: 3.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.white)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear(duration: 0.3), value: viewModel.getBreathingRatio(for: date))
            }
            
            Text(date.dayNumber)
                .font(.footnote)
                .foregroundColor(viewModel.getDayColor(for: date, isSelected: isSelected))
        }
        .frame(width: 44)
        .onAppear {
            if date <= Date() {
                viewModel.loadDailyRatio(for: date)
            }
        }
        .onTapGesture(perform: onTap)
    }
}

