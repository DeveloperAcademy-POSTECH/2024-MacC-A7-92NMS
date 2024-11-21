//
//  WatchBreathingOutroView.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/20/24.
//


import SwiftUI

struct WatchBreathingOutroView: View {
    @EnvironmentObject var router: WatchRouterManager
    @State private var opacity: Double = 1.0
    @State private var isNavigating: Bool = false

    var body: some View {
        VStack {
            WatchBreathingMP4PlayerView(videoName: "clean")

            Text("마음이 깨끗해졌어요")
                .font(.caption)
                .padding()
        }
        .opacity(opacity)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeOut(duration: 1.0)) {
                    opacity = 0.0  // Fade out
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    router.backToWatchMain()
                    router.pop()
                    
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
