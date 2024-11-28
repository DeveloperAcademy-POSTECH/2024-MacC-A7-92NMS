//
//  OnboardingStartView.swift
//  Spha
//
//  Created by LDW on 11/20/24.
//

import SwiftUI

struct OnboardingStartView: View {
    @EnvironmentObject var router: RouterManager
    
    var body: some View {
        VStack {
            Image("SPHAlogo")
                .resizable()
                .frame(width: 102, height: 30)
                .padding(.top, 80)
                .padding(.bottom, 20)

            Text("더러워진 마음을")
                .customFont(.body_1)
                .foregroundStyle(.white)
   
            Text("호흡으로 청소하세요")
                .customFont(.body_1)
                .foregroundStyle(.white)
                .padding(.bottom, 16)
            
            MP4PlayerView(videoURLString: MindDustLevel.dustLevel1.assetName)
                .frame(width: 330, height: 330)

            Spacer()
            
            Button(action: {
                router.push(view: .onboardingView)
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
            .padding(.bottom, 16)
        }
        .padding()
        .background(.black)
    }
    
}

#Preview {
    OnboardingStartView()
}
