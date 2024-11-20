//
//  MP4PlayerView.swift
//  Spha
//
//  Created by LDW on 11/20/24.
//

import SwiftUI
import AVFoundation

struct MP4PlayerView: View {
    let videoURLString: String

    var body: some View {
        if let url = Bundle.main.url(forResource: videoURLString, withExtension: "mp4") {
             MP4PlayerLayerView(videoURL: url)
                .scaledToFit()
        } else {
            Text("Wrong URL")
                .foregroundStyle(.white)
        }
        
    }
}

struct MP4PlayerLayerView: UIViewRepresentable {
    let videoURL: URL

    func makeUIView(context: Context) -> PlayerUIView {
        let view = PlayerUIView(frame: .zero, videoURL: videoURL)
        return view
    }

    func updateUIView(_ uiView: PlayerUIView, context: Context) {
        // 업데이트 시 동작 추가 가능
    }
}

class PlayerUIView: UIView {
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    init(frame: CGRect, videoURL: URL) {
        super.init(frame: frame)
        setupPlayer(videoURL: videoURL)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupPlayer(videoURL: URL) {
        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)

        if let playerLayer = playerLayer {
            playerLayer.videoGravity = .resizeAspectFill
            layer.addSublayer(playerLayer)
        }

        player?.play()
        player?.actionAtItemEnd = .none

        // 반복 재생 설정
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
    }

    @objc private func playerDidFinishPlaying() {
        player?.seek(to: .zero)
        player?.play()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
