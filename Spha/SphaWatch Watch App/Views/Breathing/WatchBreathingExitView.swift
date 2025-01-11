//
//  WatchBreathingExitView.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/19/24.
//

import SwiftUI

struct WatchBreathingExitView: View {
    @EnvironmentObject var router: WatchRouterManager
    
    var viewModel: WatchBreathingMainViewModel
    
    var body: some View {
        VStack {
            Button(action: {
                viewModel.stopBreathingCycle()
                // 버튼 클릭 시 이전 WatchBreathingSelectionView로 이동
                router.pop()
                 
            }) {
                Text(NSLocalizedString("end_button_text", comment: "종료"))
                    .font(.title3)
                    .padding(.vertical, 16)
                    .foregroundColor(.red)
                    .cornerRadius(40)
            }
            .padding(.horizontal, 36)
        }
    }
}

#Preview {
    WatchBreathingExitView(viewModel: WatchBreathingMainViewModel())
        .environmentObject(WatchRouterManager())
}
