//
//  WatchMainStatusView.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/21/24.
//

import SwiftUI

struct WatchMainStatusView: View {
    @EnvironmentObject var router: WatchRouterManager
    @StateObject private var viewModel = WatchMainStatusViewModel(HealthKitManager(), MindfulSessionManager())
    
    var body: some View {
        
        VStack{
            WatchGifPlayerView(videoName: viewModel.mindDustLevel)
            
            HStack{
                VStack{
                    HStack{
                        Text("\(viewModel.recommendedCount)")
                            .customFont(.body_1)
                            .foregroundStyle(.white)
                            .bold()
                        
                        Text("회")
                            .customFont(.caption_1)
                            .foregroundStyle(.white)
                            .bold()
                    }
                    
                    Text("권장 청소 횟수")
                        .font(.system(size: 10))
                        .foregroundStyle(.gray)
                }
                
                Rectangle()
                    .frame(width:1, height: 30)
                    .foregroundStyle(.gray)
                    .padding(.horizontal, 6)
                
                VStack{
                    HStack{
                        Text("\(viewModel.completedCount)")
                            .customFont(.body_1)
                            .foregroundStyle(.white)
                            .bold()
                        
                        Text("회")
                            .customFont(.caption_1)
                            .foregroundStyle(.white)
                            .bold()
                    }
                    Text("실행한 청소 횟수")
                        .font(.system(size: 10))
                        .foregroundStyle(.gray)
                }
            }
            .padding(.horizontal, 16)
            
        }
        .onAppear {
            // Fetch mindful sessions 호흡 실행 횟수
            viewModel.updateTodayRecord()
        }
    }
}
