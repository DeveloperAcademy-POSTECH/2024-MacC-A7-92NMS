//
//  BreathingIntroView.swift
//  Spha
//
//  Created by 추서연 on 11/15/24.
//

import SwiftUI

struct BreathingIntroView: View {
    @EnvironmentObject var router: RouterManager
    @State private var opacity: Double = 0.0
    
    var body: some View {
        VStack {
            Text("Breathing Intro")
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.0)) {
                        opacity = 1.0
                    }
                    // 일정 시간 후 BreathingMainView로 자동 전환
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        router.push(view: .breathingMainView)
                    }
                }
        }
    }

#Preview {
    BreathingIntroView()
}
