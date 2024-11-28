//
//  WatchGifPlayerView.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/28/24.
//

import SwiftUI

struct WatchGifPlayerView: View {
    var videoName: String
    @State private var imageNames: [String] = []
    @State private var currentIndex: Int = 0
    @State private var timer: Timer?

    // 이미지 파일 이름 로드
    private func loadImageNames() {
        var images: [String] = []
        var index = 0

        // 파일이 존재하는지 확인하여 로드
        while let _ = UIImage(named: "\(videoName)\(String(format: "%03d", index))") {
            let formattedName = "\(videoName)\(String(format: "%03d", index))"
            images.append(formattedName)
            index += 1
        }

        imageNames = images
    }

    // 현재 이미지 업데이트
    private func updateImage() {
        guard !imageNames.isEmpty else { return }
        currentIndex = (currentIndex + 1) % imageNames.count
    }

    // 타이머 시작
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 12.0, repeats: true) { _ in
            updateImage()
        }
    }

    // 타이머 정지
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    var body: some View {
        VStack {
            if !imageNames.isEmpty {
                Image(imageNames[currentIndex]) // 현재 프레임의 이미지
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
            } else {
                Text("Loading images...")
            }
        }
        .onAppear {
            loadImageNames() // 이미지 파일 로드
            startTimer() // 타이머 시작
        }
        .onDisappear {
            stopTimer() // 타이머 종료
        }
    }
}
