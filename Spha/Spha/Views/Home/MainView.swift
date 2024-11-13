//
//  MainView.swift
//  Spha
//
//  Created by 추서연 on 11/13/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var router: RouterManager
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("여기는 메인뷰")
            
        }
    }
}

#Preview {
    MainView()
}
