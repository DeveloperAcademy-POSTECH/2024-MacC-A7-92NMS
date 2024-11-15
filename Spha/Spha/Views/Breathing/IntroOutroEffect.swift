//
//  IntroOutroEffect.swift
//  Spha
//
//  Created by 추서연 on 11/15/24.
//

import SwiftUI

protocol IntroOutroEffect: View {
    var opacity: Double { get set }
    func startEffect()
    func resetEffect()
}

extension IntroOutroEffect {
    mutating func startEffect() {
        withAnimation(.easeIn(duration: 1.0)) {
            opacity = 1.0
        }
    }

    mutating func resetEffect() {
        withAnimation(.easeOut(duration: 1.0)) {
            opacity = 0.0
        }
    }
}
