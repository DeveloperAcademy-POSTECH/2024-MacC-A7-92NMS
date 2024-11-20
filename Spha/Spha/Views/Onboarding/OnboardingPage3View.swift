//
//  OnboardingPage3View.swift
//  Spha
//
//  Created by LDW on 11/20/24.
//

import SwiftUI

struct OnboardingPage3View: View {
    
    var body: some View {
        VStack {
            Text("HRV 심박수 데이터를 사용하여")
                .customFont(.body_1)
                .foregroundStyle(.white)
            
            Text("과부화가 왔을 때 호흡 알림을 드려요")
                .customFont(.body_1)
                .foregroundStyle(.white)
            
            Spacer()
            
            Text("온전한 서비스 이용을 위해")
                .customFont(.body_1)
                .foregroundStyle(.gray)
            
            Text("Apple Watch를 꼭 사용하세요")
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
    OnboardingPage3View()
}
