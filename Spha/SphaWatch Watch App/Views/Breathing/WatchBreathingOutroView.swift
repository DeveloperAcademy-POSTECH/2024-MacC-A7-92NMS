//
//  WatchBreathingOutroView.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/20/24.
//

import SwiftUI

struct WatchBreathingOutroView: View {
    @EnvironmentObject var router: WatchRouterManager
    @StateObject private var viewModel = WatchBreathingOutroViewModel() // ViewModel을 StateObject로 사용
    
    var body: some View {
        VStack {
            WatchBreathingMP4PlayerView(videoName: "clean")
            
            Text("마음이 깨끗해졌어요")
                .font(.caption)
                .padding()
        }
        .opacity(viewModel.opacity)  // Bind opacity from ViewModel
        .onAppear {
            viewModel.startFadeOutProcess(router: router)  // Trigger ViewModel action on appear
        }
        .navigationBarBackButtonHidden(true)
    }
}
