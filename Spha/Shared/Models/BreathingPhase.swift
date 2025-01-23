//
//  BreathingPhase.swift
//  Spha
//
//  Created by 지영 on 11/12/24.
//


import Foundation

enum BreathingPhase: String {
    case ready = "breathing_phase_ready"
    case focus = "breathing_phase_focus"
    case inhale = "breathing_phase_inhale"
    case hold1 = "breathing_phase_hold1"
    case exhale = "breathing_phase_exhale"
    case hold2 = "breathing_phase_hold2"
    case clean = "breathing_phase_clean"

    var localizedString: String {
        NSLocalizedString(self.rawValue, comment: "")
    }

    var videoName: String {
        switch self {
        case .ready: return "start"
        case .focus: return "pause"
        case .inhale: return "inhale"
        case .hold1: return "hold1"
        case .exhale: return "exhale"
        case .hold2: return "hold2"
        case .clean: return "clean"
        }
    }

    static let boxBreathingSequence: [String] = [
        BreathingPhase.ready.videoName,
        BreathingPhase.focus.videoName,
        BreathingPhase.inhale.videoName, BreathingPhase.hold1.videoName, BreathingPhase.exhale.videoName, BreathingPhase.hold2.videoName,
        BreathingPhase.inhale.videoName, BreathingPhase.hold1.videoName, BreathingPhase.exhale.videoName, BreathingPhase.hold2.videoName,
        BreathingPhase.inhale.videoName, BreathingPhase.hold1.videoName, BreathingPhase.exhale.videoName, BreathingPhase.hold2.videoName
    ]
}
