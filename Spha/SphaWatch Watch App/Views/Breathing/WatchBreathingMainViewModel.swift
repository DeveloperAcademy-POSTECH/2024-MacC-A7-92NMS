//
//  WatchBreathingMainViewModel.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/21/24.
//
import Foundation

class WatchBreathingMainViewModel: BreathingManager {
//    @Published var phaseText: String = "마음청소를 시작할게요"
    @Published var phaseText: String = BreathingPhase.ready.rawValue
    @Published var showText: Bool = true
    @Published var timerCount: Double = 0
    @Published var showTimer: Bool = false
    @Published var activeCircle: Int = 0
    @Published var isBreathingCompleted: Bool = false
    
    private var workoutManager = WorkoutManager()
    private var hapticManager = HapticManager()
    private var currentTask: Task<Void, Never>?
    
    func startBreathingIntro() {
        workoutManager.startWorkout()
        
        Task {
            await startPhase(phase: .ready, duration: 2)
            await startPhase(phase: .focus, duration: 1)
            startBreathingCycle()
        }
    }
    
    func startBreathingCycle() {
        activeCircle = 0
        repeatCycle(times: 3) {
            self.isBreathingCompleted = true
            self.workoutManager.startWorkout()
        }
    }
    
    func stopBreathingCycle() {
        hapticManager.stopHaptic() // 햅틱 피드백 멈추기
        currentTask?.cancel() // 현재 태스크 취소
        currentTask=nil
        isBreathingCompleted = false
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
        
        hapticManager.playInhaleHaptic()
        Task {
            await startPhase(phase: .inhale, duration: 4)
            hapticManager.playHoldHaptic()
            await startPhase(phase: .hold1, duration: 4)
            hapticManager.playExhaleHaptic()
            await startPhase(phase: .exhale, duration: 4)
            hapticManager.playHoldHaptic()
            await startPhase(phase: .hold2, duration: 4)
            completion()
        }
    }
    
    func videoName(for text: String) -> String {
        guard let phase = BreathingPhase(rawValue: text) else {
            return "start"
        }
        return phase.videoName
    }
    
    func startPhase(phase: BreathingPhase, duration: Double) async {
        phaseText = phase.localizedString
        showText = true
        timerCount = duration

        while timerCount > 0 {
            let sleepDuration = UInt64(min(0.1, timerCount) * 1_000_000_000) // 최소 0.1초 단위로 처리
            do {
                try await Task.sleep(nanoseconds: sleepDuration)
                timerCount -= 0.1
            } catch {
                print("Error while sleeping: \(error)")
                break
            }
        }

        if timerCount <= 0 {
            showText = false
        }
    }
}
