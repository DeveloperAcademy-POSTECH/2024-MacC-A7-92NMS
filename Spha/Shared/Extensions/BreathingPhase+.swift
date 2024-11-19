//
//  BreathingPhase+.swift
//  Spha
//
//  Created by 추서연 on 11/20/24.
//
import Foundation

extension BreathingPhase {
    // 각 호흡 단계에 맞는 텍스트를 반환
    var phaseText: String {
        switch self {
        case .inhale:
            return "숨을 들이 쉬세요"
        case .hold:
            return "잠시 멈추세요"
        case .exhale:
            return "숨을 내쉬세요"
        }
    }
}
