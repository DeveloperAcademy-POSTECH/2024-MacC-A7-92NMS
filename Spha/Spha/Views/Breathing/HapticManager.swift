//
//  HapticManager.swift
//  Spha
//
//  Created by 추서연 on 1/24/25.
//

import Foundation
import CoreHaptics

class HapticManager {
    private var hapticEngine: CHHapticEngine?

    init() {
        prepareHaptics()
    }

    private func prepareHaptics() {
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("Failed to create haptic engine: \(error)")
        }
    }
    
    func playBreatheHaptic(for duration: Double) {
        guard let hapticEngine = hapticEngine else { return }

        do {
            let steps = 30  // 강도 변화 단계를 설정 (더 많은 단계 = 더 부드러운 그라데이션)
            let stepDuration = duration / Double(steps)
            
            var events: [CHHapticEvent] = []

            for step in 0..<steps {
                // 강도를 점진적으로 증가시키고 다시 감소하도록 계산
                let normalizedStep = Double(step) / Double(steps - 1)
                let intensityValue = abs(sin(normalizedStep * .pi))  // 0에서 1로 증가 후 다시 0으로 감소
                
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(intensityValue))
                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
                
                let event = CHHapticEvent(eventType: .hapticContinuous,
                                          parameters: [intensity, sharpness],
                                          relativeTime: stepDuration * Double(step),
                                          duration: stepDuration)
                
                events.append(event)
            }
            
            // 패턴 생성
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try hapticEngine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Failed to play gradient haptic: \(error)")
        }
    }

    func playHoldHaptic(repeatCount: Int) {
        guard let hapticEngine = hapticEngine else { return }

        do {
            var events: [CHHapticEvent] = []

            for i in 0..<repeatCount {
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 3.0)
                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)

                let event = CHHapticEvent(eventType: .hapticTransient,
                                          parameters: [intensity, sharpness],
                                          relativeTime: Double(i))
                events.append(event)
            }

            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try hapticEngine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Failed to play pulsing haptic: \(error)")
        }
    }
    
    func stopHaptic() {
        guard let hapticEngine = hapticEngine else { return }

        do {
            try hapticEngine.stop()
        } catch {
            print("Failed to stop haptic engine: \(error)")
        }
    }
}
