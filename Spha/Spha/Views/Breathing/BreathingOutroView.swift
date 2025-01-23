//
//  BreathingOutroView.swift
//  Spha
//
//  Created by 추서연 on 11/16/24.
//

import SwiftUI

struct BreathingOutroView: View {
    @EnvironmentObject var router: RouterManager
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = BreathingOutroViewModel()

    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)

            VStack {
                MP4PlayerView(videoURLString: "clean")
                    .frame(width: 330, height: 330)
                    .padding(.top, 50)

               
                Text(NSLocalizedString("orb_cleaned", comment: "마음이 깨끗해졌어요"))
                    .customFont(.body_0)
                    .foregroundColor(Color.white)
                    .padding()
            }
            .opacity(viewModel.opacity)
        }
        .onAppear {
            viewModel.fadeOutAnimation {
                dismiss()
            }
            viewModel.recordTestMindfulSession()
        }
        .navigationBarBackButtonHidden(true)
    }
}

