//
//  WatchBreathingMP4PlayerView.swift
//  Spha
//
//  Created by 추서연 on 11/21/24.
//
import AVKit
import SwiftUI
import AVFoundation

struct WatchBreathingMP4PlayerView: View {
    var videoName: String

    @State private var player: AVPlayer? = nil

    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                loadVideo(named: videoName)
            }
            .onChange(of: videoName) { newVideoName in
                loadVideo(named: newVideoName)
            }
            .frame(width: 100, height: 100) // Set appropriate size for your watchOS screen
            .onDisappear {
                player?.pause() // Pause the video when the view disappears
            }
    }

    private func loadVideo(named: String) {
        if let url = Bundle.main.url(forResource: named, withExtension: "mp4") {
            player = AVPlayer(url: url)
            player?.play()
        }
    }
}
