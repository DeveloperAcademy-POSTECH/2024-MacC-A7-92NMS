//
//  WatchBreathingOutroView.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/20/24.
//

import SwiftUI

struct WatchBreathingOutroView: View {
    @EnvironmentObject var router: WatchRouterManager
    
    var body: some View {
        VStack {
            Text("마음이 깨끗해졌어요")
                .font(.caption)
                .padding()
        }
    }
}
