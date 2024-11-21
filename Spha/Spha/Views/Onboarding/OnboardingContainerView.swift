//
//  OnboardingContainerView.swift
//  Spha
//
//  Created by LDW on 11/20/24.
//

import SwiftUI

struct OnboardingContainerView: View {
    @EnvironmentObject var router: RouterManager
    @State private var currentPage = 0
    @State private var isRequestingAuthorization = false
    @State private var authorizationCompleted = false
    
    private let pageCount = 6
    private let hrvService = HealthKitManager()
    
    var body: some View {
        VStack {
            
            // 인디케이터
            HStack {
                ForEach(0..<pageCount, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color.white : Color.gray)
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut, value: currentPage)
                }
            }
            
            .padding(.bottom, 20)
            
            // TabView
            TabView(selection: $currentPage) {
                ExplainMenu().tag(0)
                BreathingGuide().tag(1)
                WatchGuide().tag(2)
                NotificationAuth().tag(3)
                HealthKitHRVAuth().tag(4)
                MindfulSessionAuth().tag(5)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // 기본 인디케이터 숨김
            
            // 버튼 (하단)
            Button(action: {
                // Switch로 구현
                
                
                if currentPage < pageCount - 1 {
                    currentPage += 1
                } else {// 시작하기 버튼을 눌렀을 때
                    // 권한 요청 메서드
                    hrvService.requestAuthorization { _ in
                        DispatchQueue.main.async {
                            router.backToMain()
                        }
                    }
                }
                
                
                
                
            }, label: {
                ZStack {
                    Rectangle()
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity, maxHeight: 57)
                        .foregroundColor(Color.white.opacity(0.25))
                    
                    Text(currentPage < pageCount - 1 ? "다음" : "시작하기")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            })
            .padding(.horizontal, 8)
            .padding(.bottom, 16)
            
        }
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    OnboardingContainerView()
}
