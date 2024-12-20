//
//  BreathingMainView.swift
//  Spha
//
//  Created by 추서연 on 11/16/24.
//
//
import SwiftUI

struct BreathingMainView<BreathViewModel>: View where BreathViewModel: BreathingManager {
    @EnvironmentObject var router: RouterManager
    @ObservedObject private var viewModel: BreathViewModel

    init(breathManager: BreathViewModel) {
        self.viewModel = breathManager
    }

    var body: some View {
        VStack {
            MultiMP4PlayerView(videoNames: BreathingPhase.boxBreathingSequence)
                .allowsHitTesting(false) 
                .frame(width: 300, height: 300)
                .padding(.top, 164)

            if viewModel.showTimer {
                Text("\(Int(viewModel.timerCount))")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top, 10)
                    .transition(.opacity)
            }
            
            Spacer()
            
            if viewModel.showText && viewModel.activeCircle < 2 {
                Text(viewModel.phaseText)
                    .customFont(.body_0)
                    .foregroundColor(.gray0)
                    .padding(.bottom, 153)
                    .transition(.opacity)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { router.backToMain() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(index < viewModel.activeCircle ? Color.white : Color.gray)
                            .frame(width: 10, height: 10)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .onAppear {
            viewModel.startBreathingIntro()
        }
        .onChange(of: viewModel.isBreathingCompleted) { oldValue, newValue in
            if !newValue { return }
            router.push(view: .breathingOutroView)
        }
    }
}

#Preview {
    BreathingMainView(breathManager: BreathingMainViewModel())
}
