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
    @Published var timerCount: Int = 0
    @Published var showTimer: Bool = false
    @Published var activeCircle: Int = 0
    @Published var isBreathingCompleted: Bool = false

    func startBreathingIntro() {
        Task {
            await startPhase(phase: .ready, duration: 2)
            await startPhase(phase: .focus, duration: 1)
            await startBreathingCycle()
        }
    }

    func startPhase(phase: BreathingPhase, duration: Int) async {
        phaseText = phase.rawValue
        timerCount = duration
        showText = true
        showTimer = true
        
        showTimer = !(phase == .ready || phase == .focus)

        while timerCount > 0 {
            do {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                timerCount -= 1
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
                await startBreathingPhase()
            }
            isBreathingCompleted = true
        }
    }

    func startBreathingPhase() async {
        await startPhase(phase: .inhale, duration: 5)
        await startPhase(phase: .hold1, duration: 5)
        await startPhase(phase: .exhale, duration: 5)
        await startPhase(phase: .hold2, duration: 5)
    }
}
