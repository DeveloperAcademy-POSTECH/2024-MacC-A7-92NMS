
//
//  ExpainMenu.swift
//  Spha
//
//  Created by LDW on 11/20/24.
//

import SwiftUI

struct ExplainMenu: View {
    
    var body: some View {
        VStack {
            Text(NSLocalizedString("onboarding_explain_text", comment: "스트레스가 쌓일 때 마다"))
                .customFont(.body_1)
                .foregroundStyle(.white)
                .padding(.top, 24)
            
            Text(NSLocalizedString("onboarding_explain_text2", comment: "마음이 더러워져요"))
                .customFont(.body_1)
                .foregroundStyle(.white)
            
            Spacer()
            
            HStack{
                VStack {
                    MP4PlayerView(videoURLString: MindDustLevel.dustLevel1.assetName)
                        .frame(width: 150, height: 150)
                    
                    Text(NSLocalizedString("mind_dust_level2", comment: ""))
                        .foregroundStyle(.white)
                        .customFont(.caption_2)
                }
                
                VStack {
                    MP4PlayerView(videoURLString: MindDustLevel.dustLevel2.assetName)
                        .frame(width: 150, height: 150)
                    
                    Text(NSLocalizedString("mind_dust_level3", comment: ""))
                        .foregroundStyle(.white)
                        .customFont(.caption_2)
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 16)
            
            HStack{
                VStack {
                    MP4PlayerView(videoURLString: MindDustLevel.dustLevel3.assetName)
                        .frame(width: 150, height: 150)
                    
                    Text(NSLocalizedString("mind_dust_level4", comment: ""))
                        .foregroundStyle(.white)
                        .customFont(.caption_2)
                }
                
                VStack {
                    MP4PlayerView(videoURLString: MindDustLevel.dustLevel4.assetName)
                        .frame(width: 150, height: 150)
                    
                    Text(NSLocalizedString("mind_dust_level5", comment: ""))
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
    ExplainMenu()
}
