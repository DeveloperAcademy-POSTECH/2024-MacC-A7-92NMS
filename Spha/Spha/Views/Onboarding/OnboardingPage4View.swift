//
//  OnboardingPage4View.swift
//  Spha
//
//  Created by LDW on 11/20/24.
//


import SwiftUI

struct OnboardingPage4View: View {
    
    var body: some View {
        VStack {
            Text("1분의 호흡으로")
                .customFont(.body_1)
                .foregroundStyle(.white)
            
            Text("마음을 깨끗이 청소하세요")
                .customFont(.body_1)
                .foregroundStyle(.white)
            
            Spacer()
            
            Circle()
                .frame(width: 15, height: 15)
                .foregroundStyle(.white)
            
            Spacer()
            
            Text("즉각적인 스트레스 해소에 도움이 되는")
                .customFont(.body_1)
                .foregroundStyle(.gray)
            
            Text("박스호흡법을 사용해요")
                .customFont(.body_1)
                .foregroundStyle(.gray)
                .padding(.bottom, 40)
            
            Button(action: {
                
            }, label: {
                ZStack{
                    Rectangle()
                        .clipShape(.rect(cornerRadius: 8) , style: FillStyle())
                        .frame(width: .infinity, height: 57)
                        .foregroundStyle(.white)
                        .opacity(0.25)
                    
                    Text("다음")
                        .customFont(.body_1)
                        .foregroundStyle(.white)
                }
            })
        }
        .padding()
        .background(.black)
    }
    
}

#Preview {
    OnboardingPage4View()
}
