//
//  BreathingManager.swift
//  Spha
//
//  Created by 추서연 on 11/21/24.
//

import Foundation

// Breathing 단계 관리 프로토콜
protocol BreathingManager : ObservableObject {
    
    var isBreathingCompleted: Bool { get set }
    var phaseText: String { get set } // 현재 단계 텍스트
    var showText: Bool { get set }   // 텍스트 표시 여부
    var timerCount: Int { get set }  // 남은 타이머 시간
    var showTimer: Bool { get set }  // 타이머 표시 여부
    var activeCircle: Int { get set } // 활성화된 동그라미 (0~3)
    
    func videoName(for text: String) -> String
    func startBreathingIntro() // 초기 인트로 시작
    func startBreathingCycle() // 호흡 사이클 시작
    func startPhase(phase: BreathingPhase, duration: Int, text: String, completion: @escaping () -> Void) // 특정 호흡 단계 시작
}
