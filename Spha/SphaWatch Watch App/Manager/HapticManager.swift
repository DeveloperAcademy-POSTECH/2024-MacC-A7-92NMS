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
    private var isHapticStopped = false

    init() {
        device = WKInterfaceDevice.current()  // WatchOS에서 WKInterfaceDevice 사용
    }

    func playInhaleHaptic() {
        Task {
            await startHapticRepeat(interval: 1.0, duration: 4) {
                if !self.isHapticStopped {
                                    self.device.play(.notification)
                                }
            }
        }
    }

    func playHoldHaptic() {
        Task {
            await startHapticRepeat(interval: 1.0, duration: 4) {
                if !self.isHapticStopped {
                                    self.device.play(.directionUp)
                                }
            }
        }
    }
    
    func playExhaleHaptic() {
        Task {
            await startHapticRepeat(interval: 1.0, duration: 4) {
                if !self.isHapticStopped {
                                    self.device.play(.notification)
                                }
            }
        }
    }

    func stopHaptic() {
        self.isHapticStopped = true
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
