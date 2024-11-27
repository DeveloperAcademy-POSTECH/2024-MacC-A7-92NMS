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
    @State private var playerOpacity: Double = 0
    
    var body: some View {
        TabView {
            VStack {
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(index < viewModel.activeCircle ? Color.gray : Color.white)
                            .frame(width: 6, height: 6)
                    }
                }
                .padding(3)
                
                Spacer()
                WatchBreathingAnimationView(videoName: viewModel.videoName(for: viewModel.phaseText))
                Spacer()
                
                if viewModel.showText {
                    Text(viewModel.phaseText)
                        .font(.caption2)
                        .transition(.opacity)
                }
            }
            .onAppear {
                viewModel.startBreathingIntro()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        playerOpacity = 1
                    }
                }
            }
            .onChange(of: viewModel.isBreathingCompleted) { oldValue, newValue in
                if newValue {
                    router.push(view: .watchbreathingOutroView)
                }
            }
            .tabItem {
                Text("Breathing Main")
            }
            
            WatchBreathingExitView(viewModel: viewModel)
                .environmentObject(viewModel)
                .tabItem {
                    Text("Exit")
                }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .navigationBarBackButtonHidden(true)
    }
}
