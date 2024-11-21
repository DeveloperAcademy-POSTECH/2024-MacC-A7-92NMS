//
//  WatchMainView.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/19/24.
//

import SwiftUI

struct WatchMainView: View {
    @EnvironmentObject var router: WatchRouterManager
    
    var body: some View {
        TabView {
            // 첫 번째 탭 (WatchMainView 탭)
            VStack {
                WatchMainStatusView()
            }
            // 두 번째 탭 (Breathing Selection View로 전환되는 탭)
            VStack {
                WatchBreathingSelectionView()
            }
        }
        .tabViewStyle(.verticalPage) // 수직으로 페이지 전환하는 스타일
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

#Preview {
    WatchMainView().environmentObject(WatchRouterManager())
}


