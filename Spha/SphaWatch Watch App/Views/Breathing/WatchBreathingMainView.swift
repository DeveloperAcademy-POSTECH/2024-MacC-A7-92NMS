//
//  WatchBreathingMainView.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/19/24.
//


import SwiftUI

struct WatchBreathingMainView: View {
    @EnvironmentObject var router: WatchRouterManager
    @StateObject private var viewModel = WatchBreathingMainViewModel()

    var body: some View {
        TabView {
            VStack {
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(index < viewModel.activeCircle ? Color.gray : Color.white)
                            .frame(width: 10, height: 10)
                    }
                }
                
                // Replace Globe with WatchBreathingMP4PlayerView
                WatchBreathingMP4PlayerView(videoName: viewModel.videoName(for: viewModel.phaseText))
                
                if viewModel.showText {
                    Text(viewModel.phaseText)
                        .font(.caption2)
                        .transition(.opacity)
                }
            }
            .onAppear {
                viewModel.startBreathingIntro()
            }
            .tabItem {
                Text("Breathing Main")
            }
            
            WatchBreathingExitView()
                .tabItem {
                    Text("Exit")
                }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .navigationBarBackButtonHidden(true)
    }
}
