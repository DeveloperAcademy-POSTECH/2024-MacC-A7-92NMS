//
//  WatchBreathingMainViewModel.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/21/24.
//
import Foundation
import SwiftUI

class WatchBreathingMainViewModel: BreathingManager {
    @Published var phaseText: String = "마음청소를 시작할게요"
    @Published var showText: Bool = true
    @Published var timerCount: Int = 0
    @Published var showTimer: Bool = false
    @Published var activeCircle: Int = 0
    @Published var isBreathingCompleted: Bool = false

    private var currentTimer: Timer?
    private var hapticManager = HapticManager()

    func startBreathingIntro() {
        startPhase(phase: .intro, duration: 2, text: "마음청소를 시작할게요") {
            self.startPhase(phase: .intro, duration: 1, text: "호흡에 집중하세요") {
                self.startBreathingCycle()
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


    func startBreathingCycle() {
        activeCircle = 0
        repeatCycle(times: 3) {
            self.isBreathingCompleted = true
        }
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
        self.hapticManager.playInhaleHaptic()
        startPhase(phase: .inhale, duration: 5, text: "숨을 들이 쉬세요") {
            self.hapticManager.playHoldHaptic()
            self.startPhase(phase: .hold1, duration: 5, text: "잠시 멈추세요") {
                self.hapticManager.playExhaleHaptic()
                self.startPhase(phase: .exhale, duration: 5, text: "숨을 내쉬세요") {
                    self.hapticManager.playHoldHaptic()
                    self.startPhase(phase: .hold2, duration: 5, text: "한번 더 멈추세요") {
                        
                        completion()
                    }
                }
            }
        }
    }

    func videoName(for text: String) -> String {
        switch text {
        case "마음청소를 시작할게요", "호흡에 집중하세요":
            return "start"
        case "숨을 들이 쉬세요":
            return "inhale"
        case "잠시 멈추세요":
            return "hold1"
        case "숨을 내쉬세요":
            return "exhale"
        case "한번 더 멈추세요":
            return "hold2"
        case "clean":
            return "clean"
        default:
            return "start"
        }
    }
}
