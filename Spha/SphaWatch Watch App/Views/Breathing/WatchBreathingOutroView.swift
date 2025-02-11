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
            WatchGifPlayerView(videoName: "clean")
            
            Text(NSLocalizedString("orb_cleaned", comment: "마음이 깨끗해졌어요"))
                .font(.caption)
                .padding()
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
        .opacity(viewModel.opacity)
        .onAppear {
            viewModel.startFadeOutProcess(router: router)
        }
        .navigationBarBackButtonHidden(true)
    }
}
