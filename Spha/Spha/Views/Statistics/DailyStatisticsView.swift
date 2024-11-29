//
//  DailyStatisticsView.swift
//  Spha
//
//  Created by 지영 on 11/15/24.
//

import SwiftUI
import Charts

struct DailyStatisticsView: View {
    @StateObject private var viewModel = DailyStatisticsViewModel(HealthKitManager(), MindfulSessionManager())
    @State private var selectedDate: Date? = nil
    
    var body: some View {
        VStack {
            HeaderView(viewModel: viewModel)
            WeeklyCalendarView(viewModel: viewModel)
            DailyChartsView(viewModel: viewModel)
            Spacer()
        }
        .background(Color.black)
    }
}

private struct HeaderView: View {
    @EnvironmentObject var router: RouterManager
    @ObservedObject var viewModel: DailyStatisticsViewModel
    @State private var showCalendar = false

    var body: some View {
        HStack {
            Button {
                router.pop()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.blue)
            }
            
            Spacer()
            
            Text(viewModel.currentDate.dateTitleString)
                .foregroundStyle(.white)
            
            Spacer()
            
            Button {
                showCalendar.toggle()
            } label: {
                Image(systemName: "calendar")
                    .foregroundStyle(.blue)
            }
            .sheet(isPresented: $showCalendar) {
                MonthlyCalendarSheet(selectedDate: $viewModel.currentDate)
                            }

        }
        .padding(12)
        .font(.system(size: 17, weight: .semibold))
    }
}

// MARK: - 월간 달력
struct MonthlyCalendarSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedDate: Date
    
    private var currentMonth: Date {
        let components = Date.calendar.dateComponents([.year, .month], from: Date())
        return Date.calendar.date(from: components)!
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 요일 헤더 (월-일)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 16) {
                    ForEach(getWeekdayHeadersStartingMonday(), id: \.self) { weekday in
                        Text(weekday)
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .frame(height: 44)
                    }
                }
                .padding(.horizontal)
                .background(Color.black)
                
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 35) {
                            ForEach((-100...1), id: \.self) { monthOffset in
                                let monthDate = Date.calendar.date(byAdding: .month, value: monthOffset, to: currentMonth)!
                                MonthView(date: monthDate, selectedDate: $selectedDate)
                                    .id(monthOffset)
                            }
                        }
                        .padding()
                        .onAppear {
                            proxy.scrollTo(0, anchor: .center)
                        }
                    }
                }
            }
            .navigationTitle("월간 달력")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("닫기") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
            .toolbarBackground(.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .background(Color.black)
        }
        .preferredColorScheme(.dark)
    }
    
    private func getWeekdayHeadersStartingMonday() -> [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        var weekdays = formatter.shortWeekdaySymbols
        // 일요일을 마지막으로 이동
        if let sunday = weekdays?.removeFirst() {
            weekdays?.append(sunday)
        }
        return weekdays?.map { $0.uppercased() } ?? []
    }
}

struct MonthView: View {
    let date: Date
    @Binding var selectedDate: Date
    @Environment(\.dismiss) var dismiss
    
    private var monthString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 16) {
            ForEach(getDaysInMonthStartingMonday(), id: \.offset) { index, date in
                if let date = date {
                    VStack(spacing: 4) {
                        // 1일인 경우에만 월 표시
                        if date.dayNumber == "1" {
                            Text(monthString)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                        } else {
                            Color.clear
                                .frame(height: 17) // 월 표시 텍스트의 높이만큼 더미 공간
                        }
                        
                        MonthlyDayView(
                            date: date,
                            isSelected: Date.calendar.isDate(date, inSameDayAs: selectedDate),
                            isToday: Date.calendar.isDate(date, inSameDayAs: Date()),
                            onTap: {
                                if date <= Date() {
                                    selectedDate = date
                                    dismiss()
                                }
                            }
                        )
                    }
                } else {
                    VStack {
                        Color.clear.frame(height: 17)
                        Color.clear.frame(width: 44, height: 44)
                    }
                }
            }
        }
    }
    
    private func getDaysInMonthStartingMonday() -> [(offset: Int, element: Date?)] {
        let range = Date.calendar.range(of: .day, in: .month, for: date)!
        let firstDayOfMonth = Date.calendar.date(from: Date.calendar.dateComponents([.year, .month], from: date))!
        var firstWeekday = Date.calendar.component(.weekday, from: firstDayOfMonth) - 2 // 월요일을 시작으로
        if firstWeekday < 0 { firstWeekday += 7 } // 일요일인 경우 조정
        
        var days = Array(repeating: nil as Date?, count: firstWeekday)
        
        for day in 1...range.count {
            if let date = Date.calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                days.append(date)
            }
        }
        
        while days.count % 7 != 0 {
            days.append(nil)
        }
        
        return days.enumerated().map { ($0, $1) }
    }
}

struct MonthlyDayView: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let onTap: () -> Void
    
    var body: some View {
        ZStack {
            // 기본 회색 원형 테두리
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 3.0)
            
            // 진행도를 나타내는 흰색 원형
            Circle()
                .trim(from: 0.0, to: 1/3)
                .stroke(style: StrokeStyle(lineWidth: 3.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(.white)
                .rotationEffect(Angle(degrees: 270.0))
            
            // 날짜 텍스트
            Text(date.dayNumber)
                .font(.footnote)
                .foregroundColor(getDayColor())
        }
        .frame(width: 44, height: 44)
        .onTapGesture(perform: onTap)
    }
    
    private func getDayColor() -> Color {
        if date > Date() {
            return .gray.opacity(0.3)
        }
        return isSelected ? .white : .white
    }
}



// MARK: - 주간 달력
private struct WeeklyCalendarView: View {
    @ObservedObject var viewModel: DailyStatisticsViewModel
    
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
        VStack(spacing: 4) {
            Text(date.dayString)
                .font(.footnote)
                .foregroundColor(date > Date() ? .gray.opacity(0.3) :
                                    isSelected ? .white : .grays2)
            
            Text(date.dayNumber)
                .font(.footnote)
                .foregroundColor(date > Date() ? .gray.opacity(0.3) :
                                    isSelected ? .white : .grays2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(isSelected ? Color.gray2 : Color.clear)
        .clipShape(Capsule())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {  // 여기에 애니메이션 추가
                onTap()
            }
        }
    }
}

// MARK: - 일일 통계 차트
private struct DailyChartsView: View {
    @ObservedObject var viewModel: DailyStatisticsViewModel
    
    var body: some View {
        VStack {
            DailyPieChartView(viewModel: viewModel)
            Divider().background(Color.gray2)
            DailyStressTrendView(viewModel: viewModel)
                .padding(.top, 20)
            Spacer()
        }
    }
}

private struct DailyPieChartView: View {
    @ObservedObject var viewModel: DailyStatisticsViewModel
    
    var body: some View {
        VStack {
            Text("일일 마음 청소 통계")
                .customFont(.body_0)
                .bold()
                .padding(.top, 20)
                .foregroundStyle(.white)
            
            ZStack {
                MP4PlayerView(videoURLString: viewModel.mindDustLevel)
                    .frame(width: 90, height: 90)
                
                Circle()
                    .stroke(lineWidth: 3.0)
                    .foregroundStyle(Color.gray1)
                
                Circle()
                    .trim(from: 0.0, to: viewModel.breathingRatio)
                    .stroke(style: StrokeStyle(lineWidth: 3.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.white)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear, value: viewModel.breathingRatio)
            }
            .padding(.vertical, 20)
                    
            HStack{
                VStack{
                    HStack{
                        Text("\(viewModel.recommendedCount)")
                            .customFont(.title_0)
                            .bold()
                        
                        Text("회")
                            .customFont(.caption_0)
                            .bold()
                    }
                    
                    Text("권장 청소 횟수")
                        .customFont(.caption_1)
                        .foregroundStyle(Color.gray0)
                }
                
                Rectangle()
                    .frame(width:1, height: 45)
                    .foregroundStyle(Color.gray1)
                    .padding(.horizontal, 24)
                
                VStack{
                    HStack{
                        Text("\(viewModel.completedCount)")
                            .customFont(.title_0)
                            .bold()
                        
                        Text("회")
                            .customFont(.caption_0)
                            .bold()
                    }
                    Text("실행한 청소 횟수")
                        .customFont(.caption_1)
                        .foregroundStyle(Color.gray0)
                }
            }
            .foregroundStyle(.white)
            .padding(.bottom, 20)
        }
    }
    
}

// MARK: - 일일 스트레스 추이 그래프
private struct DailyStressTrendView: View {
    @ObservedObject var viewModel: DailyStatisticsViewModel
    
    var body: some View {
        VStack {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("일일 스트레스 추이")
                    .customFont(.caption_0)
                    .bold()
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text("일일 과부하 수")
                    .customFont(.caption_2)
                    .bold()
                    .foregroundStyle(.grays3)
                
                Text("\(viewModel.extremeCount)")
                    .customFont(.title_0)
                
                Text("회")
                    .customFont(.caption_1)
                
            }
            .padding(EdgeInsets(top: 0, leading: 30, bottom: 20, trailing: 30))
            .foregroundStyle(.white)
            
            Chart {
                /// y축 수평 기준선
                ForEach(StressLevel.allCases, id: \.self) { level in
                    RuleMark(
                        y: .value("Level", level.numberValue)
                    )
                    .foregroundStyle(Color.gray1)
                }
                
                /// x축 수직 시간 기준선
                ForEach(Array(stride(from: 0, through: 24, by: 6)), id: \.self) { hour in
                    RuleMark(
                        x: .value("Hour", Double(hour))
                    )
                    .foregroundStyle(Color.gray1)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [2]))
                }
                
                /// 스트레스 레벨 데이터 라인과 포인트
                ForEach(viewModel.stressTrendData.indices, id: \.self) { index in
                    LineMark(
                        x: .value("Time", Calendar.current.component(.hour, from: viewModel.stressTrendData[index].0)),
                        y: .value("Stress", viewModel.stressTrendData[index].1.numberValue)
                    )
                    
                    PointMark(
                        x: .value("Time", Calendar.current.component(.hour, from: viewModel.stressTrendData[index].0)),
                        y: .value("Stress", viewModel.stressTrendData[index].1.numberValue)
                    )
                }
            }
            .padding(.horizontal, 30)
            .frame(height: 200, alignment: .leading)
            .chartYScale(domain: -0.5...3.1)
            .chartXScale(domain: -0.5...26.5)
            /// y축 설정
            .chartYAxis {
                AxisMarks(position: .leading,
                          values: StressLevel.allCases.map { Double($0.numberValue) }) { value in
                    AxisValueLabel(anchor: .center) {
                        Text(StressLevel.allCases[value.index].title)
                            .customFont(.caption_2)
                            .foregroundStyle(.grays3)
                            .frame(width: 42, alignment: .leading)
                    }
                }
            }
            /// x축 설정
            .chartXAxis {
                AxisMarks(values: .stride(by: 6)) { value in
                    AxisValueLabel(anchor: .center) {
                        Text(String(format: "%02d:00", value.index * 6))
                            .customFont(.caption_3)
                            .foregroundStyle(.grays2)
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    DailyStatisticsView()
}
