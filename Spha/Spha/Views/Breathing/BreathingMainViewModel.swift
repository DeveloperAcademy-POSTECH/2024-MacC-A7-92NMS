//
//  BreathingMainViewModel.swift
//  Spha
//
//  Created by 추서연 on 11/21/24.
//

import Foundation
import SwiftUI

// iOS ViewModel
class BreathingMainViewModel: BreathingManager {
    @Published var phaseText: String = "마음청소를 시작할게요"
    @Published var showText: Bool = true
    @Published var timerCount: Int = 0
    @Published var showTimer: Bool = false
    @Published var activeCircle: Int = 0

    private var currentTimer: Timer? // 타이머 상태 관리
    
    // 초기 인트로 시작
    func startBreathingIntro() {
        phaseText = "마음청소를 시작할게요"
        showText = true
        withAnimation { showText = true }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation { self.showText = false }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.phaseText = "호흡에 집중하세요"
                withAnimation { self.showText = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation { self.showText = false }
                    self.startBreathingCycle()
                }
            }
        }
    }

    // 호흡 사이클 시작
    func startBreathingCycle() {
        activeCircle = 0
        repeatCycle(times: 3) { /* 모든 사이클 종료 */ }
    }
    
    private func repeatCycle(times: Int, completion: @escaping () -> Void) {
        guard times > 0 else {
            completion()
            return
        }
        activeCircle += 1
        startBreathingPhase {
            self.repeatCycle(times: times - 1, completion: completion)
        }
    }

    func startBreathingPhase(completion: @escaping () -> Void) {
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

    func startPhase(phase: BreathingPhase, duration: Int, text: String, completion: @escaping () -> Void) {
        phaseText = text
        timerCount = duration
        showText = true

        currentTimer?.invalidate()
        currentTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timerCount -= 1
            if self.timerCount <= 0 {
                timer.invalidate()
                completion()
            }
        }
    }
}

