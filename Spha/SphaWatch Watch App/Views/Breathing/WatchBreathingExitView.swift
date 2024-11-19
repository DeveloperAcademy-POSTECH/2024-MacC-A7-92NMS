//
//  WatchBreathingExitView.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/19/24.
//

import SwiftUI

struct WatchBreathingExitView: View {
    @EnvironmentObject var router: WatchRouterManager
    
    var body: some View {
        VStack {
            Button(action: {
                // 버튼 클릭 시 Watch Main View로 이동
                router.backToWatchMain()
                router.pop()
                
                
            }) {
                Text("종료")
                    .font(.caption2)
                    .padding(.vertical, 16)
                    .foregroundColor(.red)
                    .cornerRadius(40)
            }
            .padding(.horizontal, 36)
        }
    }
}

#Preview {
    WatchBreathingExitView()
        .environmentObject(WatchRouterManager())
}
