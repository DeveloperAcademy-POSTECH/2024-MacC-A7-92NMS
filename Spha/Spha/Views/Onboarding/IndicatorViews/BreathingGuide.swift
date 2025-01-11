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
            Text(NSLocalizedString("onboarding_breathing_guide_title_1", comment: "1분의 호흡으로"))
                .customFont(.body_1)
                .foregroundStyle(.white)
                .padding(.top, 36)
            
            Text(NSLocalizedString("onboarding_breathing_guide_title_2", comment: "마음을 깨끗이 청소하세요"))
                .customFont(.body_1)
                .foregroundStyle(.white)
            
            Spacer()
            
            MP4PlayerView(videoURLString: "full")
                .frame(width: 200, height: 200)
            
            Spacer()
            
            Text(NSLocalizedString("onboarding_breathing_guide_subtitle_1", comment: "즉각적인 스트레스 해소에 도움이 되는"))
                .customFont(.caption_0)
                .foregroundStyle(.gray)
            
            Text(NSLocalizedString("onboarding_breathing_guide_subtitle_2", comment: "박스호흡법을 사용해요"))
                .customFont(.caption_0)
                .foregroundStyle(.gray)
                .padding(.bottom, 80)
        }
        .background(.black)
    }
    
}

#Preview {
    BreathingGuide()
}
