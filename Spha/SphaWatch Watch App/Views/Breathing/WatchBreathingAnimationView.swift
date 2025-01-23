//
//  WatchBreathingAnimationView.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/27/24.


import SwiftUI

struct WatchBreathingAnimationView: View {
    let videoName: String
    
    @State private var circleSize: CGFloat = 0
    @State private var animationDuration: Double = 0
    
    var body: some View {
        ZStack {
            // 바깥쪽 안개 같은 빛 번짐 효과
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.2), // 안개의 시작
                            Color.white.opacity(0.05),
                            Color.clear              // 안개의 끝
                        ]),
                        center: .center,
                        startRadius: circleSize * 0.5,
                        endRadius: circleSize + (circleSize * 0.3) // 범위를 줄임
                    )
                )
                .frame(width: circleSize * 1.2, height: circleSize * 1.2)
                .blur(radius: 15) // 블러 값을 줄임
            
            
            // 중심 원 (경계 흐릿함)
            Circle()
                .fill(Color.white)
                .frame(width: circleSize, height: circleSize)
                .blur(radius: 2) // 경계 블러 처리
        }
        .onChange(of: videoName) { oldValue, newValue in
            startAnimation(for: newValue)
        }
        .onAppear {
            startAnimation(for: videoName)
        }
        .animation(.easeInOut(duration: animationDuration), value: animationDuration)
    }
    
    private func startAnimation(for phase: String) {
        let animationSettings = getAnimationSettings(for: phase)
        animationDuration = animationSettings.duration
        circleSize = animationSettings.size
        
        // 딜레이가 필요한 경우 DispatchQueue를 사용
        if let delay = animationSettings.delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                circleSize = animationSettings.size
            }
        }
    }
    
    private func getAnimationSettings(for phase: String) -> (size: CGFloat, duration: Double, delay: Double?) {
        switch phase {
        case "start":
            return (size: 30, duration: 2, delay: nil) // 0에서 30으로 2초
        case "pause":
            return (size: 30, duration: 0, delay: 1) // 크기 유지, 1초 딜레이
        case "inhale":
            return (size: 85, duration: 4, delay: nil) // 30에서 85으로 4초
        case "hold1", "hold2":
            return (size: circleSize, duration: 0, delay: 4) // 크기 유지, 4초 딜레이
        case "exhale":
            return (size: 30, duration: 4, delay: nil) // 85에서 30으로 4초
        case "clean":
            return (size: 0, duration: 0, delay: nil) // 초기화
        default:
            return (size: 0, duration: 0, delay: nil) // 기본값
        }
    }
}

#Preview {
    WatchBreathingAnimationView(videoName: "inhale")
}
