//
//  BreathingManager.swift
//  Spha
//
//  Created by 추서연 on 11/21/24.
//

import Foundation

@MainActor
protocol BreathingManager: ObservableObject {
    var isBreathingCompleted: Bool { get set }
    var phaseText: String { get set } 
    var showText: Bool { get set }
    var timerCount: Int { get set }
    var showTimer: Bool { get set }
    var activeCircle: Int { get set }

    func startBreathingIntro() // 초기 인트로 시작
    func startBreathingCycle()// 호흡 사이클 시작
    func startPhase(phase: BreathingPhase, duration: Int) async // 특정 호흡 단계 시작
}

