//
//  DailyStatisticsView.swift
//  Spha
//
//  Created by 지영 on 11/15/24.
//

import SwiftUI

struct DailyStatisticsView: View {
    @State private var selectedDate: Int? = nil
    
    var body: some View {
        WeeklyCalendarHeaderView(selectedDate: $selectedDate)
        InfoView()
    }
}

private struct InfoView: View {
    var body: some View {
        Text("hello")
    }
}

private struct WeeklyCalendarHeaderView: View {
    @Binding var selectedDate: Int?
    let colors: [Color] = [.red, .blue, .green, .pink, .purple]
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.horizontal) {
                HStack(alignment: .center) {
                    ForEach(colors, id: \.self) { color in
                        WeeklyView(selectedDate: $selectedDate)
                            .frame(width: geo.size.width, height: 56)
                    } // forEach
                } // hStack
                .scrollTargetLayout()
            } // scrollView
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
        }
    } // body
}


private struct WeeklyView: View {
    @Binding var selectedDate: Int?
    let colors: [Color] = [.red, .blue, .green, .pink, .purple, .black, .orange]
    
    var body: some View {
        HStack(spacing: 32) {
            ForEach(Array(colors.enumerated()), id: \.element) { index, color in
                DayItem(date: index, selectedDate: $selectedDate)
            }
        }
        .padding(.horizontal)
    }
}

private struct DayItem: View {
    let date: Int
    @Binding var selectedDate: Int?
    
    var body: some View {
        VStack(spacing: 4) {
            Text("금")
                .font(.system(size: 14))
            Text("15")
                .font(.system(size: 14))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(selectedDate == date ? .gray : .clear)
        .clipShape(Capsule())
        .onTapGesture {
            selectedDate = date
        }
    }
}

#Preview {
    DailyStatisticsView()
}
