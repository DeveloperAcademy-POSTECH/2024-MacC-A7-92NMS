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
        PlayerUIView(frame: .zero, videoURL: videoURL)
    }

    func updateUIView(_ uiView: PlayerUIView, context: Context) {
        // URL이 변경되었을 때 플레이어 업데이트
        uiView.updateVideoURL(videoURL)
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
        // 기존 레이어 제거
        playerLayer?.removeFromSuperlayer()

        // AVPlayer 및 AVPlayerLayer 생성
        let newPlayer = AVPlayer(url: videoURL)
        let newPlayerLayer = AVPlayerLayer(player: newPlayer)
        newPlayerLayer.videoGravity = .resizeAspectFill

        // 안전하게 레이어 추가
        layer.addSublayer(newPlayerLayer)

        player = newPlayer
        playerLayer = newPlayerLayer

        // AVPlayer 설정
        player?.play()
        player?.actionAtItemEnd = .none

        // 반복 재생 설정
        if let currentItem = player?.currentItem {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(playerDidFinishPlaying),
                name: .AVPlayerItemDidPlayToEndTime,
                object: currentItem
            )
        }
    }

    func updateVideoURL(_ newURL: URL) {
        guard let currentAsset = player?.currentItem?.asset as? AVURLAsset else {
            setupPlayer(videoURL: newURL)
            return
        }
        
        if currentAsset.url != newURL {
            setupPlayer(videoURL: newURL)
        }
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
