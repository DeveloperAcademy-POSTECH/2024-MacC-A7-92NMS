//
//  BreathingView.swift
//  Spha
//
//  Created by 추서연 on 11/20/24.
//

import SwiftUI

struct BreathingView: View {
    @ObservedObject var viewModel: BreathingViewModel
    var onFinish: () -> Void

    var body: some View {
        VStack {
            Spacer()

            if viewModel.showTimer {
                Text("\(viewModel.timerCount)")
                    .font(.largeTitle)
                    .bold()
                    .padding()
            }

            if viewModel.showText {
                Text(viewModel.phaseText)
                    .font(.title)
                    .padding(.bottom, 16)
            }

            HStack {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(index < viewModel.activeCircle ? Color.black : Color.gray)
                        .frame(width: 10, height: 10)
                }
            }
        }
        .onAppear {
            viewModel.startBreathingIntro {
                viewModel.startBreathingCycle(times: 3) {
                    onFinish()
                }
            }
        }
    }
}
