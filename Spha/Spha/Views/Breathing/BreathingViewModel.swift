//
//  BreathingViewModel.swift
//  Spha
//
//  Created by 추서연 on 11/20/24.
//

//
//
//import SwiftUI
//import Combine
//
//class BreathingViewModel: ObservableObject {
//    @Published var phaseText: String = "마음청소를 시작할게요"
//    @Published var timerCount: Int = 0
//    @Published var showTimer: Bool = false
//    @Published var showText: Bool = true
//    @Published var activeCircle: Int = 0
//    @Published var currentPhase: BreathingPhase? = nil
//    
//    private var timer: Timer?
//    
//    func startBreathingIntro() {
//        // 첫 번째 텍스트 단계 - 마음청소
//        phaseText = "마음청소를 시작할게요"
//        showText = true
//        withAnimation {
//            showText = true
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            withAnimation {
//                self.showText = false
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                // 두 번째 텍스트 단계 - 호흡에 집중
//                self.phaseText = "호흡에 집중하세요"
//                withAnimation {
//                    self.showText = true
//                }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    withAnimation {
//                        self.showText = false
//                    }
//                    self.startBreathingCycle()
//                }
//            }
//        }
//    }
//    
//    private func startBreathingCycle() {
//        activeCircle = 0
//        repeatCycle(times: 3) {
//            // 호흡이 끝난 후 뷰에서 전환하도록 처리
//        }
//    }
//    
//    private func repeatCycle(times: Int, completion: @escaping () -> Void) {
//        guard times > 0 else {
//            completion()
//            return
//        }
//        
//        activeCircle += 1
//        startBreathingPhase {
//            self.repeatCycle(times: times - 1, completion: completion)
//        }
//    }
//    
//    private func startBreathingPhase(completion: @escaping () -> Void) {
//        showTimer = true
//        
//        startPhase(phase: .inhale, duration: 5, text: "숨을 들이 쉬세요") {
//            self.startPhase(phase: .hold, duration: 5, text: "잠시 멈추세요") {
//                self.startPhase(phase: .exhale, duration: 5, text: "숨을 내쉬세요") {
//                    self.startPhase(phase: .hold, duration: 5, text: "잠시 멈추세요") {
//                        completion()
//                    }
//                }
//            }
//        }
//    }
//    
//    private func startPhase(phase: BreathingPhase, duration: Int, text: String, completion: @escaping () -> Void) {
//        currentPhase = phase
//        phaseText = text
//        timerCount = duration
//        showText = true
//        
//        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
//            self.timerCount -= 1
//            if self.timerCount <= 0 {
//                timer.invalidate()
//                completion()
//            }
//        }
//    }
//    
//    // Stop any active timers
//    func stopTimer() {
//        timer?.invalidate()
//        timer = nil
//    }
//}
//
