//
//  OnboardingPage1View.swift
//  Spha
//
//  Created by LDW on 11/20/24.
//

import SwiftUI

struct OnboardingPage1View: View {
    var body: some View {
        VStack {
            Text("Spha-")
                .customFont(.title_0)
                .foregroundStyle(.white)
            
            Spacer()
            
            Image(systemName: "paperplane.circle.fill")
                .resizable()
                .frame(width: 270, height: 270)
                .foregroundStyle(.white)
            
            Spacer()
            
            Text("더러워진 마음을")
                .customFont(.body_1)
                .foregroundStyle(.white)
   
            Text("호흡으로 청소하세요")
                .customFont(.body_1)
                .foregroundStyle(.white)
            
            Spacer()
            
            Button(action: {
                
            }, label: {
                ZStack{
                    Rectangle()
                        .clipShape(.rect(cornerRadius: 8) , style: FillStyle())
                        .frame(width: .infinity, height: 57)
                        .foregroundStyle(.white)
                        .opacity(0.25)
                    
                    Text("시작하기")
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
    OnboardingPage1View()
}
