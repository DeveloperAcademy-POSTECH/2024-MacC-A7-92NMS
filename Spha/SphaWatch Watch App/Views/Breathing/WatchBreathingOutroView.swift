//
//  WatchBreathingOutroView.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/20/24.
//

import SwiftUI

struct WatchBreathingOutroView: View {
    @EnvironmentObject var router: WatchRouterManager
    @StateObject private var viewModel = WatchBreathingOutroViewModel() // ViewModel을 StateObject로 사용
    
    @State private var opacity: Double = 1.0
    
    var body: some View {
        VStack {
            WatchBreathingMP4PlayerView(videoName: "clean")
            
            Text("마음이 깨끗해졌어요")
                .font(.caption)
                .padding()
            
            Text(viewModel.statusMessage) // ViewModel의 상태 메시지 표시
                .font(.subheadline)
                .padding()
        }
        .opacity(opacity)
        .onAppear {
            // 오늘의 Mindful 세션 조회 후 개수 +1
            viewModel.fetchTodaySessions()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeOut(duration: 1.0)) {
                    opacity = 0.0  // Fade out
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    router.backToWatchMain()
                    router.pop()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
