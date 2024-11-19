//
//  VerticalTEstView.swift
//  SphaWatch Watch App
//
//  Created by 추서연 on 11/19/24.
//

import SwiftUI

struct ContentView2: View {
    var body: some View {
        TabView {
            // First Page
            VStack {
                Text("Page 1")
                    .font(.largeTitle)
                    .padding()
            }
            .tabItem {
                Text("First")
            }

            // Second Page
            VStack {
                Text("Page 2")
                    .font(.largeTitle)
                    .padding()
            }
            .tabItem {
                Text("Second")
            }
        }
        .tabViewStyle(.verticalPage)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView2()
}
