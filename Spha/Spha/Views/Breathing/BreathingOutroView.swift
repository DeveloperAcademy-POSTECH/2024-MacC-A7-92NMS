//
//  BreathingOutroView.swift
//  Spha
//
//  Created by 추서연 on 11/15/24.
//

import SwiftUI
struct BreathingOutroView: View {
    @EnvironmentObject var router: RouterManager
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("BreathingIntroView")
        }
    }
}
#Preview {
    BreathingOutroView()
}
