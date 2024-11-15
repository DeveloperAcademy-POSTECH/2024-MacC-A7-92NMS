//
//  BreathingOutroView.swift
//  Spha
//
//  Created by 추서연 on 11/16/24.
//

import SwiftUI

struct BreathingOutroView: View {
    @EnvironmentObject var router: RouterManager
    @State private var fadeOpacity: Double = 1.0 // 초기 값 1.0 (완전 불투명)

    var body: some View {
        ZStack {
            // MainView가 보이는 배경
            router.view(for: .mainView)

            // BreathingOutroView 오버레이
            VStack {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                Text("호흡이 끝났습니다")
                    .font(.title)
                    .padding()
            }
            .opacity(fadeOpacity) // 투명도 제어
            .background(Color.white.opacity(fadeOpacity)) // 배경 포함
        }
        .onAppear {
            startFadeOut()
        }
    }

    private func startFadeOut() {
        // 1초 후 페이드 아웃
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeOut(duration: 1)) {
                fadeOpacity = 0.0 // 투명도 변경
            }
            // 페이드 아웃이 완료된 후 MainView로 상태 유지
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                router.backToMain()
            }
        }
    }
}

#Preview {
    BreathingOutroView()
        .environmentObject(RouterManager())
}


