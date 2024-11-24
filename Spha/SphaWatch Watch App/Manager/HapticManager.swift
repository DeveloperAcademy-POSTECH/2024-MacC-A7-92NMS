//
//  HapticManager.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/22/24.
//

import SwiftUI
import Foundation
import WatchKit

class HapticManager {
    private var device: WKInterfaceDevice

    init() {
        device = WKInterfaceDevice.current()  // WatchOS에서 WKInterfaceDevice 사용
    }

    func playInhaleHaptic() {
        Task {
            await startHapticRepeat(interval: 0.5, duration: 5) {
                self.device.play(.stop)
            }
        }
    }

    func playHoldHaptic() {
        Task {
            await startHapticRepeat(interval: 0.5, duration: 5) {
                self.device.play(.start)
            }
        }
    }
    
    func playExhaleHaptic() {
        Task {
            await startHapticRepeat(interval: 0.5, duration: 5) {
                self.device.play(.success)
            }
        }
    }

    func stopHaptic() {
        device.play(.stop)
    }

    private func startHapticRepeat(interval: TimeInterval, duration: TimeInterval, hapticAction: @escaping () -> Void) async {
        var elapsed: TimeInterval = 0
        
        while elapsed < duration {
            await Task.sleep(UInt64(interval * 1_000_000_000)) 
            elapsed += interval
            hapticAction()
        }
    }
}
