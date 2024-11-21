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
                .padding(5)
            Text("즉각적인 스트레스를 완화해주는 호흡법이에요")
                .customFont(.caption_3)
                .padding(.bottom,28)
            
            HStack{
                Rectangle()
                    .frame(width: 26, height: 5)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding(3)
                Rectangle()
                    .frame(width: 26, height: 5)
                    .cornerRadius(10)
                    .foregroundColor(.gray2)
                    .padding(3)
                Rectangle()
                    .frame(width: 26, height: 5)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding(3)
                Rectangle()
                    .frame(width: 26, height: 5)
                    .cornerRadius(10)
                    .foregroundColor(.gray2)
                    .padding(3)
            }
            .padding(.bottom,28)
            
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

