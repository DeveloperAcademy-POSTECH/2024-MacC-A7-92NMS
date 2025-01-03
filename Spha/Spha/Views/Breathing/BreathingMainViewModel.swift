//
//  BreathingMainViewModel.swift
//  Spha
//
//  Created by 추서연 on 11/21/24.
//

import Foundation
import SwiftUI

@MainActor
class BreathingMainViewModel: BreathingManager, ObservableObject {
    @Published var phaseText: String = BreathingPhase.ready.rawValue
    @Published var showText: Bool = true
    @Published var timerCount: Double = 0
    @Published var showTimer: Bool = false
    @Published var activeCircle: Int = 0
    @Published var isBreathingCompleted: Bool = false

    func startBreathingIntro() {
        Task {
            await startPhase(phase: .ready, duration: 2)
            await startPhase(phase: .focus, duration: 1.01)
            startBreathingCycle()
        }
    }

    func startPhase(phase: BreathingPhase, duration: Double) async {
        phaseText = phase.rawValue
        timerCount = duration
        showText = true
        showTimer = true

        showTimer = !(phase == .ready || phase == .focus)

        while timerCount > 0 {
            do {
                let sleepDuration = UInt64(1_000_000_000 * min(1.0, timerCount)) // 1초 또는 남은 시간을 나노초로 변환
                try await Task.sleep(nanoseconds: sleepDuration)
                timerCount -= min(1.0, timerCount) // 남은 시간을 조정
            } catch {
                print("Task was interrupted: \(error)")
                break
            }
        }

        showTimer = false
    }

    func startBreathingCycle() {
        Task {
            for cycle in 1...3 {
                activeCircle = cycle
                showText = activeCircle < 2
                await startBreathingPhase()
            }
            isBreathingCompleted = true
        }
    }

    func startBreathingPhase() async {
        await startPhase(phase: .inhale, duration: 4)
        await startPhase(phase: .hold1, duration: 4)
        await startPhase(phase: .exhale, duration: 4)
        await startPhase(phase: .hold2, duration: 4)
    }
}
