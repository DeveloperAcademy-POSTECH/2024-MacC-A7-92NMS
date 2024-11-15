//
//  BreathingMainView.swift
//  Spha
//
//  Created by 추서연 on 11/15/24.
//
import SwiftUI

struct BreathingMainView: View {
    @EnvironmentObject var router: RouterManager
    @State private var currentPhase: BreathingPhase? = nil
    @State private var phaseText: String = "마음청소를 시작할게요"
    @State private var showText: Bool = true

    var body: some View {
        VStack {
            // 호흡 단계에 맞는 이미지 (필요시 교체 가능)
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            // 호흡 단계 텍스트
            if showText {
                Text(phaseText)
                    .font(.title)
                    .padding()
                    .transition(.opacity)
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    router.backToMain() // MainView로 돌아가며 상태 초기화
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.blue)
                }
            }
        }
        .onAppear {
            startBreathingIntro()
        }
    }
    
    // 호흡 준비 시작 - 첫 번째와 두 번째 멘트
    private func startBreathingIntro() {
        // 첫 번째 텍스트 단계 - 마음청소
        phaseText = "마음청소를 시작할게요"
        withAnimation {
            showText = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                showText = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                // 두 번째 텍스트 단계 - 호흡에 집중
                phaseText = "호흡에 집중하세요"
                withAnimation {
                    showText = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        showText = false
                    }
                    startBreathingPhase()
                }
            }
        }
    }
    
    // 호흡 단계 시작 (inhale, hold, exhale)
    private func startBreathingPhase() {
        // 호흡 단계 시작
        currentPhase = .inhale
        phaseText = "숨을 들이 쉬세요"
        showText = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            currentPhase = .hold
            phaseText = "잠시 멈추세요"
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                currentPhase = .exhale
                phaseText = "숨을 내쉬세요"
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    currentPhase = .hold
                    phaseText = "잠시 멈추세요"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        finishBreathing()
                    }
                }
            }
        }
    }
    
    // 호흡이 끝났을 때 메시지 표시
    private func finishBreathing() {
        phaseText = "호흡 끝"
        showText = true
    }
}

#Preview {
    BreathingMainView()
}
