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
                    MP4PlayerView(videoURLString: MindDustLevel.dustLevel1.assetName)
                        .frame(width: 180, height: 180)
                    
                    Text("먼지가 조금 생겼어요")
                        .foregroundStyle(.white)
                        .customFont(.caption_2)
                }
//                .padding(.trailing, 32)
                
                VStack {
                    MP4PlayerView(videoURLString: MindDustLevel.dustLevel2.assetName)
                        .frame(width: 180, height: 180)
                    
                    Text("점점 흐려져요")
                        .foregroundStyle(.white)
                        .customFont(.caption_2)
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 16)
            
            HStack{
                VStack {
                    MP4PlayerView(videoURLString: MindDustLevel.dustLevel3.assetName)
                        .frame(width: 180, height: 180)
                    
                    Text("탁하고 답답해요")
                        .foregroundStyle(.white)
                        .customFont(.caption_2)
                }
//                .padding(.trailing, 32)
                
                VStack {
                    MP4PlayerView(videoURLString: MindDustLevel.dustLevel4.assetName)
                        .frame(width: 180, height: 180)
                    
                    Text("터질 것 같아요")
                        .foregroundStyle(.white)
                        .customFont(.caption_2)
                }
            }
            .padding(.horizontal, 32)
            
            Spacer()

        }
        .padding()
        .background(.black)
    }
    
}

#Preview {
    OnboardingPage2View()
}
