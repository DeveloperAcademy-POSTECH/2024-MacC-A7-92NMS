//
//  BreathingOutroView.swift
//  Spha
//
//  Created by 추서연 on 11/16/24.
//

import SwiftUI

struct BreathingOutroView: View {
    @EnvironmentObject var router: RouterManager

    @State private var opacity: Double = 1.0
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                MP4PlayerView(videoURLString: "clean")
                    .frame(width: 330, height: 330)
                    .padding(.top,50)
                
                Text("마음이 깨끗해졌어요")
                    .customFont(.body_0)
                    .foregroundColor(Color.white)
                    .padding()
            }
            .opacity(opacity)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeOut(duration: 1.0)) {
                    opacity = 0.0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    router.backToMain()
                    
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

