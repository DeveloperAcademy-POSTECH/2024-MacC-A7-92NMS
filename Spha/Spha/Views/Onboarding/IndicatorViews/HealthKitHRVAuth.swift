//
//  OnboardingPage5View.swift
//  Spha
//
//  Created by LDW on 11/20/24.
//


import SwiftUI

struct HealthKitHRVAuth: View {
    
    var body: some View {
        VStack {
            Text(NSLocalizedString("onboarding_healthkit_access_text", comment: "자동 스트레스 추적을 위해"))
                .customFont(.body_1)
                .foregroundStyle(.white)
                .padding(. top, 16)

            Text(NSLocalizedString("onboarding_healthkit_access_text2", comment: "Apple 건강에 대한 엑세스를 허용 해주세요"))
                .customFont(.body_1)
                .foregroundStyle(.white)
            
            Spacer()
            
            Image("healthAuthImage")
                .resizable()
                .scaledToFit()
                .frame(height: 400)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.6)]),
                        startPoint: .center,
                        endPoint: .bottom
                    )
                    .frame(height: UIScreen.main.bounds.height * 0.3)
                        .edgesIgnoringSafeArea(.bottom),
                    alignment: .bottom
                )
    
            Spacer()
        }
        .padding()
        .background(.black)
    }
}

#Preview {
    HealthKitHRVAuth()
}
