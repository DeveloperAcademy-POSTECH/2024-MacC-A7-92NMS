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
    @Published var currentVideo: String = "start" // Keep track of the current video name

    @Published var isFinished: Bool = false // Flag to signal completion and navigate to outro view
    
    private var currentTimer: Timer?

    func startBreathingIntro() {
        phaseText = "마음청소를 시작할게요"
        currentVideo = videoName(for: phaseText)
        showText = true
        withAnimation { showText = true }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation { self.showText = false }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.phaseText = "호흡에 집중하세요"
                self.currentVideo = self.videoName(for: self.phaseText)
                withAnimation { self.showText = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation { self.showText = false }
                    self.startBreathingCycle()
                }
            }
        }
    }

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
            self.startPhase(phase: .hold1, duration: 5, text: "잠시 멈추세요") {
                self.startPhase(phase: .exhale, duration: 5, text: "숨을 내쉬세요") {
                    self.startPhase(phase: .hold2, duration: 5, text: "한번 더 멈추세요") {
                        completion()
                    }
                }
            }
        }
    }

    func startPhase(phase: BreathingPhase, duration: Int, text: String, completion: @escaping () -> Void) {
        phaseText = text
        currentVideo = videoName(for: text)
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

    // Map the phase text to the corresponding video name
    func videoName(for text: String) -> String {
        switch text {
        case "마음청소를 시작할게요":
            return "start"
        case "호흡에 집중하세요":
            return "pause"
        case "숨을 들이 쉬세요":
            return "inhale"
        case "잠시 멈추세요":
            return "hold1"
        case "숨을 내쉬세요":
            return "exhale"
        case "한번 더 멈추세요":
            return "hold2"
        default:
            return "start"
        }
    }

    // Once the entire cycle is complete, set isFinished to true
    func completeBreathingCycle() {
        isFinished = true
    }
}

