//
//  WatchBreathingSelectionView.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/19/24.
//


import SwiftUI

struct WatchBreathingSelectionView: View {
    @EnvironmentObject var router: WatchRouterManager
    
    var body: some View {
        VStack {
            Text("박스 호흡법")
                .font(.caption)
                .padding()
            
            Spacer()
            
            // '마음청소 시작하기'를 버튼으로 변경
            Button(action: {
                // 버튼 클릭 시 Breathing Main View로 이동
                router.push(view: .watchbreathingMainView)
            }) {
                Text("마음청소 시작하기")
                    .font(.caption2)
                    .padding(.vertical,16)
                    .padding(.horizontal,24)
                    .foregroundColor(.white)
                    .cornerRadius(26)
            }
        }
    }
}

#Preview {
    WatchBreathingSelectionView()
        .environmentObject(WatchRouterManager())
}

