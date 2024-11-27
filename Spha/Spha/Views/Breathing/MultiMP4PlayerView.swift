//
//  MultiMP4PlayerView.swift
//  Spha
//
//  Created by LDW on 11/27/24.
//

import SwiftUI
import AVFoundation
import _AVKit_SwiftUI

struct MultiMP4PlayerView: View {
    let videoNames: [String]
    @State private var player: AVQueuePlayer?

    var body: some View {
        VStack {
            if let player = player {
                VideoPlayer(player: player)
                    .scaledToFit()
            } else {
                Text("No Videos Available")
                    .foregroundColor(.white)
            }
        }
        .onAppear {
            setupQueuePlayer()
        }
    }

    private func setupQueuePlayer() {
        guard !videoNames.isEmpty else { return }
        
        player = AVQueuePlayer()

        // 비디오 이름을 URL로 변환하고 큐에 추가
        for videoName in videoNames {
            if let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
                let playerItem = AVPlayerItem(url: url)
                player?.insert(playerItem, after: nil)
            } else {
                print("Error: Video \(videoName) not found.")
            }
        }
        player?.play()
    }
}
