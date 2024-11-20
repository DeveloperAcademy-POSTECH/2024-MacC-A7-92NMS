//
//  BreathingMainView.swift
//  Spha
//
//  Created by 추서연 on 11/16/24.
//
//
import SwiftUI

struct BreathingMainView: View {
    @EnvironmentObject var router: RouterManager
    @StateObject private var viewModel = BreathingMainViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Spacer()
            
            if viewModel.showTimer {
                Text("\(viewModel.timerCount)")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                    .transition(.opacity)
            }
            
            if viewModel.showText {
                Text(viewModel.phaseText)
                    .font(.title)
                    .padding(.bottom, 159)
                    .transition(.opacity)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { router.backToMain() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.blue)
                }
            }
        }
        .onAppear {
            viewModel.startBreathingIntro()
        }
    }
}
