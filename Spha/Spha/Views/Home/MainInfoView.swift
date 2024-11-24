//
//  MainInfoView.swift
//  Spha
//
//  Created by LDW on 11/21/24.
//

import SwiftUI

struct MainInfoView: View {
    @EnvironmentObject var router: RouterManager
    
    var body: some View {
        ScrollView {
            topView()
            
            VStack {
                mindOrbGuide()
                    .padding(.bottom, 32)
                
                Spacer()
                
                mindCleaningGuide()
                    .padding(.bottom, 32)
                
                Spacer()
                
                mindOrbStateExplain()
                    .padding(.bottom, 32)
                
                Spacer()
                
                notificationGuide()
                    .padding(.bottom, 32)
            }
            .padding(.leading, 20)
        }
        .background(.black)
    }
    
    private func topView() -> some View {
        ZStack{
            HStack {
                Spacer()
                
                Text("호흡 권장 단계 설명")
                    .foregroundStyle(.white)
                    .font(.system(size: 20))
                    .bold()
                
                Spacer()
            }
            .padding(8)
    
            HStack{
                Spacer()
                
                Button(action: {
                    router.backToMain()
                }, label: {
                    Text("확인")
                        .foregroundStyle(.blue)
                        .bold()
                })
            }
            .padding(.trailing, 16)
        }
    }
    
    private func mindOrbGuide() -> some View {
        VStack{
            HStack{
                Text("마음구슬이란?")
                    .foregroundStyle(.white)
                    .customFont(.body_1)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.top, 16)
            
            Spacer()
            
            HStack{
                Text("내면의 답답한 마음을 시각화한 Spha의 심볼이에요.")
                    .foregroundStyle(.white)
                    .customFont(.caption_1)
                Spacer()
            }
            
            HStack{
                Text("(권장 청소 횟수) - (실행한 청소 횟수)")
                    .foregroundStyle(.white)
                    .customFont(.caption_1_SB)
                
                Text("로 모습이 변화해요.")
                    .foregroundStyle(.white)
                    .customFont(.caption_1)
                
                Spacer()
            }
        }
    }
    
    private func mindCleaningGuide() -> some View {
        VStack{
            HStack{
                Text("마음청소란?")
                    .foregroundStyle(.white)
                    .customFont(.body_1)
                Spacer()
            }
            
            Spacer()
            
            HStack {
                Text("Spha에서 제공하는 호흡법을 말해요. 호흡을 천천히 들이마시고, 멈추고, 내쉬고, 다시 멈추는 과정을 1분동안 반복하는 박스 호흡법으로 마음구슬을 청소 할 수 있어요.")
                    .foregroundStyle(.white)
                    .customFont(.caption_1)
                    .multilineTextAlignment(.leading)
                
                    Spacer()
            }
            .padding(.bottom, 12)

            HStack {
                Text("이 과정은 마음에 즉각적인 평온을 가져오는 간단하면서도 효과적인 방법이에요.")
                    .foregroundStyle(.white)
                    .customFont(.caption_1)
                    .multilineTextAlignment(.leading)
            
                Spacer()
            }
        }
    }
    
    private func mindOrbStateExplain() -> some View {
        VStack{
            HStack{
                Text("마음구슬의 단계별 상태")
                    .foregroundStyle(.white)
                    .customFont(.body_1)
                Spacer()
            }
            
            mindOrb(dustLevel: MindDustLevel.none, detailDescription: "애플워치를 착용하면 스트레스를 측정하여 마음구슬 상태를 알 수 있어요.")
            
            mindOrb(dustLevel: MindDustLevel.dustLevel1, detailDescription: "스트레스가 쌓이지 않은 상태에요.\n호흡을 통해 구슬을 깨끗하게 관리할 수 있어요.")
            
            mindOrb(dustLevel: MindDustLevel.dustLevel2, detailDescription: "호흡을 한 번 하지 않았을 때의 상태에요.")
            
            mindOrb(dustLevel: MindDustLevel.dustLevel3, detailDescription: "호흡을 두 번 하지 않았을 때의 상태에요.")
            
            mindOrb(dustLevel: MindDustLevel.dustLevel4, detailDescription: "호흡을 세 번 하지 않았을 때의 상태에요.")
            
            mindOrb(dustLevel: MindDustLevel.dustLevel5, detailDescription: "호흡을 네 번 이상 하지 않았을 때의 상태에요.")
        }
    }
    
    private func mindOrb(dustLevel: MindDustLevel, detailDescription: String) -> some View {
        HStack{
            MP4PlayerView(videoURLString: dustLevel.assetName)
                .frame(width: 135, height: 135)
            
            VStack{
                HStack{
                    Text("\(dustLevel.description)")
                        .foregroundStyle(.white)
                        .customFont(.caption_1)
                        .foregroundStyle(Color.gray)
                    
                    Spacer()
                }
                .padding(.bottom, 8)
                .padding(.top, 36)
                
                HStack{
                    Text(detailDescription)
                        .foregroundStyle(.white)
                        .customFont(.caption_2)
                    Spacer()
                }
                
                Spacer()
            }
        }
        
    }
    
    private func notificationGuide() -> some View {
        VStack{
            HStack{
                Text("호흡 권장 알림이 언제 오나요?")
                    .foregroundStyle(.white)
                    .customFont(.body_1)
                Spacer()
            }
            .padding(.top, 16)
            
            Spacer()
            
            HStack{
                Text("HRV는 심박 간격 사이의 변화를 측정하는 지표로, 스트레스 수준을 평가하는 데 활용돼요.")
                    .foregroundStyle(.white)
                    .customFont(.caption_1)
                Spacer()
            }
            .padding(.bottom, 8)
            
            Spacer()
            
            
            HStack{
                Text("Spha는 HRV 수치를 훌륭함, 정상, 주의 필요, 과부하로 분류하여, 주의 필요 기준치 이상일 경우 사용자가 호흡 연습을 통해 스트레스를 완화할 수 있도록 권장하고 있어요.")
                    .foregroundStyle(.white)
                    .customFont(.caption_1)
                Spacer()
            }
        }
    }
}

#Preview {
    MainInfoView()
}
