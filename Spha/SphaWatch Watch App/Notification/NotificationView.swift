//
//  NotificationView.swift
//  SphaWatch Watch App
//
//  Created by 지영 on 11/13/24.
//

import SwiftUI

struct NotificationView: View {
    let notiManager = NotificationManager()
    
    var body: some View {
        VStack {
            Button("테스트 알림") {
                notiManager.handleStress()
            }
        }
    }
}
#Preview {
    NotificationView()
}
