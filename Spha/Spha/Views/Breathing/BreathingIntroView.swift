//
//  BreathingIntroView.swift
//  Spha
//
//  Created by 추서연 on 11/15/24.
//
import SwiftUI

struct BreathingIntroView: View, IntroOutroEffect {
    @EnvironmentObject var router: RouterManager
    @State private var opacity: Double = 0.0

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("BreathingIntroView")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blue)
        .opacity(opacity)
        .onAppear {
            startEffect()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                router.push(view: .breathingMainView)
            }
        }
    }
}
