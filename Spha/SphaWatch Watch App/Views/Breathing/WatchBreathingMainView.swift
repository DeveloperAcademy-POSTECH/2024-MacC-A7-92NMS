//
//  WatchBreathingMainView.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/19/24.
//

import SwiftUI

struct WatchBreathingMainView: View {
    @EnvironmentObject var router: WatchRouterManager
    
    var body: some View {
        TabView {
            VStack {
                Text("여기가 호흡뷰")
                    .font(.largeTitle)
                    .padding()
            }
            .tabItem {
                Text("Breathing Main")
            }
            
            WatchBreathingExitView()
                .tabItem {
                    Text("Exit")
                }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))  // PageTabViewStyle을 사용하여 스와이프 가능하게 설정
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    WatchBreathingMainView()
        .environmentObject(WatchRouterManager())
}
