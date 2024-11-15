//
//  BreathingMainView.swift
//  Spha
//
//  Created by 추서연 on 11/15/24.
//

import SwiftUI

struct BreathingMainView: View {
    @EnvironmentObject var router: RouterManager
    @State private var currentPhase: BreathingPhase? = nil
    @State private var phaseText: String = "마음청소를 시작할게요"
    @State private var showText: Bool = true
    @State private var timerCount: Int = 0 // 타이머 값
    @State private var showTimer: Bool = false // 타이머 표시 여부
    @State private var activeCircle: Int = 0 // 현재 활성화된 동그라미 (0~3)

    var body: some View {
        VStack {
            // 호흡 단계에 맞는 이미지 (필요시 교체 가능)
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Spacer()
            
            // 타이머
            if showTimer {
                Text("\(timerCount)")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                    .transition(.opacity)
            }
            
            // 호흡 단계 텍스트
            if showText {
                Text(phaseText)
                    .font(.title)
                    .padding(.bottom, 159)
                    .transition(.opacity)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    router.backToMain() // MainView로 돌아가며 상태 초기화
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.blue)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(index < activeCircle ? Color.black : Color.gray)
                            .frame(width: 10, height: 10)
                    }
                }
            }
        }
        .onAppear {
            startBreathingIntro()
        }
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
                    startBreathingCycle()
                }
            }
        }
    }
    
    // 전체 호흡 반복 사이클 시작
    private func startBreathingCycle() {
        activeCircle = 0 // 초기화
        repeatCycle(times: 3) {
            finishBreathing()
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
        currentPhase = phase
        phaseText = text
        timerCount = duration
        showText = true

        // 타이머 시작
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timerCount -= 1
            if self.timerCount <= 0 {
                timer.invalidate()
                completion()
            }
        }
    }
    
    // 호흡이 끝났을 때 메시지 표시
    private func finishBreathing() {
        phaseText = "호흡이 끝났습니다!"
        showText = true
        showTimer = false
    }
}

#Preview {
    BreathingMainView()
}
