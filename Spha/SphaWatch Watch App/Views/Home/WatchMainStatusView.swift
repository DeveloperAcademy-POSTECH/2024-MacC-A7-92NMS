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
                        
                        Text(NSLocalizedString("count_format", comment: "회"))
                            .customFont(.caption_1)
                            .foregroundStyle(.white)
                            .bold()
                    }
                    
                    Text(NSLocalizedString("recommended_clean_count", comment: "권장 청소 횟수"))
                        .font(.system(size: 9))
                        .foregroundStyle(.gray)
                }
                
                Rectangle()
                    .frame(width:1, height: 30)
                    .foregroundStyle(.gray)
                    .padding(.horizontal, 5)
                
                VStack{
                    HStack{
                        Text("\(viewModel.completedCount)")
                            .customFont(.body_1)
                            .foregroundStyle(.white)
                            .bold()
                        
                        Text(NSLocalizedString("count_format", comment: "회"))
                            .customFont(.caption_1)
                            .foregroundStyle(.white)
                            .bold()
                    }
                    Text(NSLocalizedString("executed_clean_count", comment: "실행한 청소 횟수"))
                        .font(.system(size: 9))
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
