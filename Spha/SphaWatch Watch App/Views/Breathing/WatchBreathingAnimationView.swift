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
                            Color.white.opacity(0.3), // 안개의 시작
                            Color.white.opacity(0.1),
                            Color.white.opacity(0.0)  // 안개의 끝
                        ]),
                        center: .center,
                        startRadius: circleSize,
                        endRadius: circleSize + (circleSize / 3)
                    )
                )
                .frame(width: circleSize * 1.4, height: circleSize * 1.4)
                .blur(radius: 30) // 더 부드럽게 확산
            
            // 중심 원 (경계 흐릿함)
            Circle()
                .fill(Color.white)
                .frame(width: circleSize, height: circleSize)
                .blur(radius: 2) // 경계 블러 처리
        }
        .onChange(of: videoName) { newVideoName in
            startAnimation(for: newVideoName)
        }
        .onAppear {
            startAnimation(for: videoName)
        }
        .animation(.easeInOut(duration: animationDuration), value: circleSize)
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
            return (size: 90, duration: 5, delay: nil) // 30에서 90으로 5초
        case "hold1", "hold2":
            return (size: circleSize, duration: 0, delay: 5) // 크기 유지, 5초 딜레이
        case "exhale":
            return (size: 30, duration: 5, delay: nil) // 90에서 30으로 5초
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
