//
//  OnboardingPage4View.swift
//  Spha
//
//  Created by LDW on 11/20/24.
//


import SwiftUI

struct WatchGuide: View {
    
    var body: some View {
        VStack {
            Text("HRV 심박수 데이터를 사용하여")
                .customFont(.body_1)
                .foregroundStyle(.white)
                .padding(.top, 36)
            
            Text("과부하가 왔을 때 호흡 알림을 드려요")
                .customFont(.body_1)
                .foregroundStyle(.white)
            
            Spacer()
            
            Image("watchGuideImage")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            
            Spacer()
            
            Text("온전한 서비스 이용을 위해")
                .customFont(.caption_0)
                .foregroundStyle(.gray)
            
            Text("Apple Watch를 사용하세요")
                .customFont(.caption_0)
                .foregroundStyle(.gray)
                .padding(.bottom, 80)
        }
        .background(.black)
    }
}

#Preview {
    WatchGuide()
}
