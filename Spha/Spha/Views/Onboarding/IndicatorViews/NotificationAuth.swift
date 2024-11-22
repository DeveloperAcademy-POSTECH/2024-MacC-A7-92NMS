//
//  NotificationAuth.swift
//  Spha
//
//  Created by LDW on 11/21/24.
//

import SwiftUI

struct NotificationAuth: View {
    
    var body: some View {
        VStack {
            Text("HRV 심박수 데이터를 사용하여")
                .customFont(.body_1)
                .foregroundStyle(.white)
            
            Text("과부화가 왔을 때 호흡 알림을 드려요")
                .customFont(.body_1)
                .foregroundStyle(.white)
            
            Spacer()
            
            Image("NotiAlert")
                .frame(width: 15, height: 15)
                .foregroundStyle(.white)
            
            Spacer()
            
            Text("온전한 서비스 이용을 위해")
                .customFont(.body_1)
                .foregroundStyle(.gray)
            
            Text("Apple Watch를 꼭 사용하세요")
                .customFont(.body_1)
                .foregroundStyle(.gray)
                .padding(.bottom, 40)
        }
        .padding()
        .background(.black)
    }
    
}

#Preview {
    NotificationAuth()
}
