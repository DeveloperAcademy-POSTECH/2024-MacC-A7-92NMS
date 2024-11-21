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
        ZStack {
            // Custom player view
            CustomAVPlayerView(player: player)
                .onAppear {
                    loadVideo(named: videoName)
                }
                .onChange(of: videoName) { newVideoName in
                    loadVideo(named: newVideoName)
                }
                .frame(width: 200, height: 200) // Set appropriate size for your watchOS screen
        }
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

struct CustomAVPlayerView: UIViewRepresentable {
    var player: AVPlayer?

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let player = player {
            // Ensure the player is always updated in the view
            (uiView.layer.sublayers?.first as? AVPlayerLayer)?.player = player
        }
    }
}





