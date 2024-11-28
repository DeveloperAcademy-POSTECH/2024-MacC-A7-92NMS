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
        }
        .padding(12)
        .font(.system(size: 17, weight: .semibold))
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
