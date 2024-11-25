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
            WeeklyCalendarHeaderView(viewModel: viewModel)
            DailyChartsView(viewModel: viewModel)
            Spacer()
        }
        .background(Color.black)
    }
}

// MARK: - 주간 달력
private struct WeeklyCalendarHeaderView: View {
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
        VStack(spacing: 0) {
            Text(date.dayString)
                .font(.caption)
                .foregroundColor(date > Date() ? .gray.opacity(0.3) :
                                    isSelected ? .white : .gray)
            
            Text(date.dayNumber)
                .foregroundColor(date > Date() ? .gray.opacity(0.3) :
                                    isSelected ? .white : .white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(isSelected ? Color.gray : Color.clear)
        .clipShape(Capsule())
        .onTapGesture(perform: onTap)
    }
}

// MARK: - 일일 통계 차트
private struct DailyChartsView: View {
    @ObservedObject var viewModel: DailyStatisticsViewModel
    
    var body: some View {
        VStack {
            DailyPieChartView(viewModel: viewModel)
            Divider().background(.white)
            DailyStressTrendView(viewModel: viewModel)
        }
    }
}

private struct DailyPieChartView: View {
    @StateObject private var mainViewModel = MainViewModel()
    @ObservedObject var viewModel: DailyStatisticsViewModel
    
    var body: some View {
        Text("일일 마음 청소 통계")
            .foregroundStyle(.white)
            .padding(.top, 36)
        
        ZStack {
            MP4PlayerView(videoURLString: mainViewModel.remainingCleaningCount.assetName)
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
                        .foregroundStyle(.white)
                        .bold()
                    
                    Text("회")
                        .customFont(.caption_0)
                        .foregroundStyle(.white)
                        .bold()
                }
                
                Text("권장 청소 횟수")
                    .customFont(.caption_1)
                    .foregroundStyle(.gray)
            }
            
            Rectangle()
                .frame(width:1, height: 30)
                .foregroundStyle(.gray)
                .padding(.horizontal, 16)
            
            VStack{
                HStack{
                    Text("\(viewModel.completedCount)")
                        .customFont(.title_0)
                        .foregroundStyle(.white)
                        .bold()
                    
                    Text("회")
                        .customFont(.caption_0)
                        .foregroundStyle(.white)
                        .bold()
                }
                Text("실행한 청소 횟수")
                    .customFont(.caption_1)
                    .foregroundStyle(.gray)
            }
        }
        .padding(.bottom, 36)
    }
}

// MARK: - 일일 스트레스 추이 그래프
private struct DailyStressTrendView: View {
    @ObservedObject var viewModel: DailyStatisticsViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("일일 스트레스 추이")
                Spacer()
                Text("일일 과부하 수 \(viewModel.extremeCount)회")
            }
            .foregroundStyle(.white)
            .padding()
            
            Chart {
                /// y축 수평 기준선
                ForEach(StressLevel.allCases, id: \.self) { level in
                    RuleMark(
                        y: .value("Level", level.numberValue)
                    )
                    .foregroundStyle(Color.gray0)
                }
                
                /// x축 수직 시간 기준선
                ForEach(Array(stride(from: 0, through: 24, by: 6)), id: \.self) { hour in
                    RuleMark(
                        x: .value("Hour", Double(hour))
                    )
                    .foregroundStyle(Color.gray0)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                }
                
                /// 스트레스 레벨 데이터 라인과 포인트
                ForEach(viewModel.stressTrendData.indices, id: \.self) { index in
                    LineMark(
                        x: .value("Time", Calendar.current.component(.hour, from: viewModel.stressTrendData[index].0)),
                        y: .value("Stress", viewModel.stressTrendData[index].1.numberValue)
                    )
                    .foregroundStyle(.white)
                    
                    PointMark(
                        x: .value("Time", Calendar.current.component(.hour, from: viewModel.stressTrendData[index].0)),
                        y: .value("Stress", viewModel.stressTrendData[index].1.numberValue)
                    )
                    .foregroundStyle(.white)
                }
            }
            .chartYScale(domain: -0.5...3.5)
            .chartXScale(domain: -0.5...24.5)
            /// y축 설정
            .chartYAxis {
                AxisMarks(position: .leading,
                          values: StressLevel.allCases.map { Double($0.numberValue) }) { value in
                    AxisValueLabel {
                        Text(StressLevel.allCases[value.index].title)
                            .font(.system(size: 12))
                            .foregroundStyle(Color.gray0)
                    }
                }
            }
            /// x축 설정
            .chartXAxis {
                AxisMarks(values: .stride(by: 6)) { value in
                    AxisValueLabel(anchor: .center) {
                        Text(String(format: "%02d:00", value.index * 6))
                            .font(.system(size: 8))
                            .foregroundStyle(Color.gray0)
                    }
                }
            }
            .frame(height: 200)
            .padding()
        }
    }
}

#Preview {
    DailyStatisticsView()
}
