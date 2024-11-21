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
    
    private let pageCount = 4
    private let hrvService = HealthKitManager()
    
    var body: some View {
        VStack {
            ZStack {
                HStack{
                    // 뒤로가기 버튼
                    Button(action: {
                        // 권한 요청 바로 실행
                        // async await 사용
                        hrvService.requestAuthorization { _ in
                            DispatchQueue.main.sync {
                                router.backToMain()
                            }
                        }
                        
                    }, label: {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .frame(width: 12, height: 18)
                                .foregroundStyle(.white)
                    })
                    .padding(.leading, 16)
                    
                    Spacer()
                }
                
                // 인디케이터
                HStack {
                    ForEach(0..<pageCount, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.white : Color.gray)
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
            }
            .padding(.bottom, 20)
            
            // TabView
            TabView(selection: $currentPage) {
                OnboardingPage2View().tag(0)
                OnboardingPage3View().tag(1)
                OnboardingPage4View().tag(2)
                OnboardingPage5View().tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // 기본 인디케이터 숨김
            
            // 버튼 (하단)
            Button(action: {
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
