//
//  BreathingTestView.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/19/24.
//

import SwiftUI

struct BreathingTestView: View {
    @EnvironmentObject var router: WatchRouterManager
    var body: some View {
        VStack {
            Text("여기는 테스트")
                .font(.largeTitle)
                .padding()
        }
    }
}

#Preview {
    BreathingTestView()
}
