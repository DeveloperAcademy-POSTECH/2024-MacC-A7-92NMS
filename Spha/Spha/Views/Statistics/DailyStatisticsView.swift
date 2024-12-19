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
            
            // 주간 달력 TabView
            TabView(selection: $viewModel.selectedDate) {
                ForEach(viewModel.weeks, id: \.first) { week in
                    WeekView(week: week, viewModel: viewModel)
                        .tag(week[0])
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(maxHeight: 56)
            .padding(.horizontal, 24)
            
            // 일별 통계 TabView
            TabView(selection: $viewModel.currentDate) {
                ForEach(viewModel.availableDates, id: \.self) { date in
                    DailyChartsView(viewModel: viewModel)
                        .tag(date)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onChange(of: viewModel.currentDate) { newDate in
                // 현재 날짜가 속한 주의 날짜들 확인
                if let currentWeek = viewModel.weeks.first(where: { week in
                    week.contains(where: { date in
                        Calendar.current.isDate(date, inSameDayAs: newDate)
                    })
                }) {
                    viewModel.selectedDate = currentWeek[0]
                } else {
                    // 현재 주에 없는 날짜라면 새로운 주 로드
                    let newWeek = viewModel.getWeekForDate(newDate)
                    if newDate < viewModel.weeks.first![0] {
                        viewModel.weeks.insert(newWeek, at: 0)
                        viewModel.selectedDate = newWeek[0]
                    } else {
                        viewModel.weeks.append(newWeek)
                        viewModel.selectedDate = newWeek[0]
                    }
                }
                
                // 추가 날짜 로드
                if newDate == viewModel.availableDates.first {
                    viewModel.loadPreviousDay()
                } else if newDate == viewModel.availableDates.last {
                    viewModel.loadNextDay()
                }
            }
        }
        .background(Color.black)
    }
}

// MARK: - Header
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
                MonthlyCalendarSheetView(viewModel: viewModel, selectedDate: $viewModel.currentDate)
            }
        }
        .padding(12)
        .font(.system(size: 17, weight: .semibold))
    }
}


// MARK: - 주간 달력
private struct WeekView: View {
    let week: [Date]
    @ObservedObject var viewModel: DailyStatisticsViewModel
    
    var body: some View {
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
    }
}

private struct DayItemView: View {
    let date: Date
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
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

// MARK: - 일별 통계 차트
private struct DailyChartsView: View {
    @ObservedObject var viewModel: DailyStatisticsViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            DailyPieChartView(viewModel: viewModel)
            Divider().background(Color.gray2)
            DailyStressTrendView(viewModel: viewModel)
            Spacer()
        }
    }
}

private struct DailyPieChartView: View {
    @ObservedObject var viewModel: DailyStatisticsViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Spacer()
                
                Text("일일 마음 청소 통계")
                    .customFont(.body_0)
                    .bold()
                    .foregroundStyle(.white)
                
                ZStack {
                    let circleSize = min(geometry.size.width/2.5, geometry.size.height/2.5)
                    
                    MP4PlayerView(videoURLString: viewModel.mindDustLevel)
                        .frame(width: circleSize * 0.8, height: circleSize * 0.8)
                    
                    Circle()
                        .stroke(lineWidth: 3.0)
                        .foregroundStyle(Color.gray1)
                        .frame(width: circleSize, height: circleSize)
                    
                    Circle()
                        .trim(from: 0.0, to: viewModel.breathingRatio)
                        .stroke(style: StrokeStyle(lineWidth: 3.0, lineCap: .round, lineJoin: .round))
                        .foregroundColor(.white)
                        .rotationEffect(Angle(degrees: 270.0))
                        .animation(.linear, value: viewModel.breathingRatio)
                        .frame(width: circleSize, height: circleSize)
                }
                .padding(.vertical, 16)
                
                HStack {
                    VStack {
                        HStack {
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
                .padding(.bottom, geometry.size.height/36)
                
                Spacer()
            }
            .frame(width: geometry.size.width)
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
