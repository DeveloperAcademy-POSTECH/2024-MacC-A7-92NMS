//
//  WatchBreathingMainView.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/19/24.
//


import SwiftUI

struct WatchBreathingMainView: View {
    @EnvironmentObject var router: WatchRouterManager
    
    // 상태 변수들
    @State private var showBreathingIntro = true // 인트로를 보여줄지 여부
    @State private var breathingIntroOpacity: Double = 0.0 // 인트로 페이드 인 효과
    @State private var phaseText: String = "마음청소를 시작할게요" // 단계별 텍스트
    @State private var showText: Bool = true // 텍스트 표시 여부
    @State private var timerCount: Int = 0 // 타이머 값
    @State private var showTimer: Bool = false // 타이머 표시 여부
    @State private var activeCircle: Int = 0 // 현재 활성화된 동그라미 (0~3)
    @State private var currentTimer: Timer? // 타이머 상태 관리
    
    var body: some View {
        VStack {
            
            TabView {
                VStack {
                    // 인트로 화면 (페이드인 효과 없이)
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
                            // 애니메이션 없이 바로 나타나게 설정
                            breathingIntroOpacity = 1.0
                            
                            // 일정 시간 후 메인 화면으로 이동
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                showBreathingIntro = false
                                startBreathingIntro() // 호흡 시작
                            }
                        }
                    } else {
                        // 호흡 메인 화면
                        VStack {
                            
                            
                            HStack(spacing: 8) {
                                ForEach(0..<3, id: \.self) { index in
                                    Circle()
                                        .fill(index < activeCircle ? Color.gray : Color.white)
                                        .frame(width: 10, height: 10)
                                }
                            }
                            Image(systemName: "globe")
                                .imageScale(.large)
                                .foregroundStyle(.tint)
                            
                            
                            // 호흡 단계 텍스트
                            if showText {
                                Text(phaseText)
                                    .font(.caption2)
                                    .transition(.opacity)
                            }
                        }
                        .navigationBarBackButtonHidden(true)
                        .onAppear {
                            startBreathingIntro() // 호흡 시작
                        }
                    }
                    
                }
                .tabItem {
                    Text("Breathing Main")
                }
                
                WatchBreathingExitView()
                    .tabItem {
                        Text("Exit")
                    }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))  // PageTabViewStyle을 사용하여 스와이프 가능하게 설정
            .navigationBarBackButtonHidden(true)
            
            
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))  // PageTabViewStyle을 사용하여 스와이프 가능하게 설정
        .navigationBarBackButtonHidden(true)
    }
    
    // 호흡 준비 시작 - 첫 번째와 두 번째 멘트
    private func startBreathingIntro() {
        // 첫 번째 텍스트 단계 - 마음청소
        phaseText = "마음청소를 시작할게요"
        showText = true
        withAnimation {
            showText = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                showText = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                // 두 번째 텍스트 단계 - 호흡에 집중
                phaseText = "호흡에 집중하세요"
                withAnimation {
                    showText = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        showText = false
                    }
                    startBreathingCycle() // 호흡 사이클 시작
                }
            }
        }
    }
    
    // 전체 호흡 반복 사이클 시작
    private func startBreathingCycle() {
        activeCircle = 0 // 초기화
        repeatCycle(times: 3) {
            finishBreathing() // 호흡 종료 처리
        }
    }
    
    private func finishBreathing() {
        withAnimation {
            router.push(view: .watchbreathingOutroView) // Outro로 라우팅
        }
    }
    
    // 반복 사이클
    private func repeatCycle(times: Int, completion: @escaping () -> Void) {
        guard times > 0 else {
            completion()
            return
        }
        
        activeCircle += 1 // 동그라미 활성화 업데이트
        startBreathingPhase {
            repeatCycle(times: times - 1, completion: completion)
        }
    }
    
    // 호흡 단계 시작 (inhale, hold, exhale)
    private func startBreathingPhase(completion: @escaping () -> Void) {
        showTimer = true
        
        startPhase(phase: .inhale, duration: 5, text: "숨을 들이 쉬세요") {
            self.startPhase(phase: .hold, duration: 5, text: "잠시 멈추세요") {
                self.startPhase(phase: .exhale, duration: 5, text: "숨을 내쉬세요") {
                    self.startPhase(phase: .hold, duration: 5, text: "잠시 멈추세요") {
                        completion()
                    }
                }
            }
        }
    }
    
    // 특정 호흡 단계 진행
    private func startPhase(phase: BreathingPhase, duration: Int, text: String, completion: @escaping () -> Void) {
        phaseText = text
        timerCount = duration
        showText = true
        
        // 이전 타이머가 있으면 정리
        currentTimer?.invalidate()
        
        // 새로운 타이머 시작
        currentTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timerCount -= 1
            if self.timerCount <= 0 {
                timer.invalidate()
                completion()
            }
        }
    }
}

#Preview {
    WatchBreathingMainView()
        .environmentObject(WatchRouterManager())
}
