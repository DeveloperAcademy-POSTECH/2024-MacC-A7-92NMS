//
//  OnboardingPage4View.swift
//  Spha
//
//  Created by LDW on 11/20/24.
//


import SwiftUI

struct BreathingGuide: View {
    
    var body: some View {
        VStack {
            Text("1분의 호흡으로")
                .customFont(.body_1)
                .foregroundStyle(.white)
            
            Text("마음을 깨끗이 청소하세요")
                .customFont(.body_1)
                .foregroundStyle(.white)
            
            Spacer()
            
            MP4PlayerView(videoURLString: "full")
                .frame(width: 180, height: 180)
            
            Spacer()
            
            Text("즉각적인 스트레스 해소에 도움이 되는")
                .customFont(.body_1)
                .foregroundStyle(.gray)
            
            Text("박스호흡법을 사용해요")
                .customFont(.body_1)
                .foregroundStyle(.gray)
                .padding(.bottom, 40)
        }
        .background(.black)
    }
    
}

#Preview {
    BreathingGuide()
}
