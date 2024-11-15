//
//  BreathingMainView.swift
//  Spha
//
//  Created by 추서연 on 11/14/24.
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
    }
}

#Preview {
    BreathingMainView()
}
