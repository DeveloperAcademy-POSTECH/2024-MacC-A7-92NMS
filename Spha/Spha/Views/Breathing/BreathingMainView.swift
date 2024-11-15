//
//  BreathingMainView.swift
//  Spha
//
//  Created by 추서연 on 11/15/24.
//

import SwiftUI

struct BreathingMainView: View {
    @EnvironmentObject var router: RouterManager

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("BreathingMainView")
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    router.backToMain() // MainView로 돌아가며 상태 초기화
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}


#Preview {
    BreathingMainView()
}
