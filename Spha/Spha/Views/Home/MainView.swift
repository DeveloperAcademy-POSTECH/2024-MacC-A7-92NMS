//
//  MainView.swift
//  Spha
//
//  Created by 추서연 on 11/13/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var router: RouterManager
    @State private var showBreathingIntro = false
    @State private var breathingIntroOpacity: Double = 0.0

    var body: some View {
        ZStack {
            // 메인 뷰
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("여기는 메인뷰")
                
                Button("Start Breathing") {
                    startBreathingIntro()
                }
            }.navigationBarBackButtonHidden(true)
            
            // BreathingIntroView 오버레이 뷰
            if showBreathingIntro {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("BreathingIntroView")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue)
                .opacity(breathingIntroOpacity) // 페이드인 효과
                .onAppear {
                    withAnimation(.easeIn(duration: 1.0)) {
                        breathingIntroOpacity = 1.0
                    }
                    // 일정 시간 후 다른 화면으로 이동
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        router.push(view: .breathingMainView)
                    }
                }
            }
        }
        .onAppear {
            // Notification을 관찰하여 상태 초기화
            NotificationCenter.default.addObserver(forName: RouterManager.backToMainNotification, object: nil, queue: .main) { _ in
                resetBreathingIntro()
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: RouterManager.backToMainNotification, object: nil)
        }
    }
    
    // BreathingIntroView 상태 초기화 및 페이드인
    private func resetBreathingIntro() {
        showBreathingIntro = false
        breathingIntroOpacity = 0.0
    }
    
    // BreathingIntroView 시작
    private func startBreathingIntro() {
        showBreathingIntro = true
        breathingIntroOpacity = 0.0 // 초기화
    }
}

#Preview {
    MainView()
}

