//
//  HapticManager.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/22/24.
//

import Foundation
import SwiftUI
import WatchKit

// HapticManager 클래스 정의
class HapticManager {
    private var device: WKInterfaceDevice
    private var timer: Timer?

    init() {
        device = WKInterfaceDevice.current()  // WatchOS에서 WKInterfaceDevice 사용
    }
    
    func playInhaleHaptic() {
        startHapticRepeat(interval: 0.5, duration: 5) {
                    self.device.play(.start)
                }
    }
    
    func playHoldHaptic() {
        device.play(.stop)
        startHapticRepeat(interval: 0.5, duration: 5) {
                    self.device.play(.stop)
                }
    }
    
    func playExhaleHaptic() {
        startHapticRepeat(interval: 0.5, duration: 5) {
                    self.device.play(.success)
                }
    }
    
    private func startHapticRepeat(interval: TimeInterval, duration: TimeInterval, hapticAction: @escaping () -> Void) {
            var elapsed: TimeInterval = 0

            // 이전 타이머가 있으면 취소
            timer?.invalidate()

            // 타이머 시작
            timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
                elapsed += interval
                hapticAction()  // 햅틱 재생
                if elapsed >= duration {
                    timer.invalidate()  // 지정된 시간이 지나면 타이머 종료
                }
            }
        }
}
