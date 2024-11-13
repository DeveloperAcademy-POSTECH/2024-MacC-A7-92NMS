//
//  ContentView.swift
//  Spha
//
//  Created by 지영 on 11/12/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var router: RouterManager
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
          
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
