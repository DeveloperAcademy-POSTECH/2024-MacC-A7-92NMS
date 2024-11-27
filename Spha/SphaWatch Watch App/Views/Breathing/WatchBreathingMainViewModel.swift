//
//  WatchBreathingMainViewModel.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/21/24.
//
import Foundation

class WatchBreathingMainViewModel: BreathingManager {
    @Published var phaseText: String = "마음청소를 시작할게요"
    @Published var showText: Bool = true
    @Published var timerCount: Int = 0
    @Published var showTimer: Bool = false
    @Published var activeCircle: Int = 0
    @Published var isBreathingCompleted: Bool = false
    
    private var hapticManager = HapticManager()
    private var currentTask: Task<Void, Never>?
    
    func startBreathingIntro() {
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
            await startPhase(phase: .inhale, duration: 5)
            hapticManager.playHoldHaptic()
            await startPhase(phase: .hold1, duration: 5)
            hapticManager.playExhaleHaptic()
            await startPhase(phase: .exhale, duration: 5)
            hapticManager.playHoldHaptic()
            await startPhase(phase: .hold2, duration: 5)
            completion()
        }
    }
    
    func videoName(for text: String) -> String {
        guard let phase = BreathingPhase(rawValue: text) else {
            return "start"
        }
        return phase.videoName
    }
    
    func startPhase(phase: BreathingPhase, duration: Int) async {
        phaseText = phase.rawValue
        showText = true
        timerCount = duration
        
        for _ in 0..<duration {
            do {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                timerCount -= 1
            } catch {
                print("Error while sleeping: \(error)")
            }
        }
        
        if timerCount <= 0 {
            
        }
    }
}
