//
//  BreathingPhase.swift
//  Spha
//
//  Created by 지영 on 11/12/24.
//


import Foundation

enum BreathingPhase: String {
    case ready = "마음청소를 시작할게요"
    case focus = "호흡에 집중하세요"
    case inhale = "숨을 들이 쉬세요"
    case hold1 = "잠시 멈추세요"
    case exhale = "숨을 내쉬세요"
    case hold2 = "한번 더 멈추세요"
    case clean = "clean"
    
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
}
