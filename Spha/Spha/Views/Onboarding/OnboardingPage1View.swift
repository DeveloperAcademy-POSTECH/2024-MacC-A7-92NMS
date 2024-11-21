//
//  OnboardingPage1View.swift
//  Spha
//
//  Created by LDW on 11/20/24.
//

import SwiftUI

struct OnboardingPage1View: View {
    @EnvironmentObject var router: RouterManager
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Spha-")
                .customFont(.title_0)
                .foregroundStyle(.white)
            
            Spacer()
            
//            Image(systemName: "paperplane.circle.fill")
//                .resizable()
//                .frame(width: 270, height: 270)
//                .foregroundStyle(.white)

            MP4PlayerView(videoURLString: MindDustLevel.dustLevel2.assetName)
                .frame(width: 330, height: 330)
            
            Spacer()
            
            Text("더러워진 마음을")
                .customFont(.body_1)
                .foregroundStyle(.white)
   
            Text("호흡으로 청소하세요")
                .customFont(.body_1)
                .foregroundStyle(.white)
            
            Spacer()
            
            Button(action: {
                router.push(view: .Onboarding2View)
            }, label: {
                ZStack {
                    Rectangle()
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity, maxHeight: 57)
                        .foregroundColor(Color.white.opacity(0.25))
                    
                    Text("시작하기")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            })
        }
        .padding()
        .background(.black)
    }
    
}

#Preview {
    OnboardingPage1View()
}
