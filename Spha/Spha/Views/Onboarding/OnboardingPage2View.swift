//
//  OnboardingPage2View.swift
//  Spha
//
//  Created by LDW on 11/20/24.
//

import SwiftUI

struct OnboardingPage2View: View {
    var body: some View {
        VStack {
            Text("스트레스가 쌓일 때 마다")
                .customFont(.body_1)
                .foregroundStyle(.white)
            
            Text("마음이 점점 더러워져요")
                .customFont(.body_1)
                .foregroundStyle(.white)
            
            Spacer()
            
            HStack{
                VStack {
                    Image(systemName: "paperplane.circle.fill")
                        .resizable()
                        .frame(width: 130, height: 130)
                        .foregroundStyle(.white)
                    
                    Text("먼지가 조금 생겼어요")
                        .foregroundStyle(.white)
                        .customFont(.caption_2)
                }
                
                Spacer()
                
                VStack {
                    Image(systemName: "paperplane.circle.fill")
                        .resizable()
                        .frame(width: 130, height: 130)
                        .foregroundStyle(.white)
                    
                    Text("점점 흐려져요")
                        .foregroundStyle(.white)
                        .customFont(.caption_2)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            
            HStack{
                VStack {
                    Image(systemName: "paperplane.circle.fill")
                        .resizable()
                        .frame(width: 130, height: 130)
                        .foregroundStyle(.white)
                    
                    Text("탁하고 답답해요")
                        .foregroundStyle(.white)
                        .customFont(.caption_2)
                }
                
                Spacer()
                
                VStack {
                    Image(systemName: "paperplane.circle.fill")
                        .resizable()
                        .frame(width: 130, height: 130)
                        .foregroundStyle(.white)
                    
                    Text("터질 것 같아요")
                        .foregroundStyle(.white)
                        .customFont(.caption_2)
                }
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
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
    OnboardingPage2View()
}
