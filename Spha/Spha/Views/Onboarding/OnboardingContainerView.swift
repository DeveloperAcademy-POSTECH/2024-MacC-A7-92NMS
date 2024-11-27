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
    
    private let pageCount = 5
    private let hrvService: HealthKitInterface
    private let mindfulService: MindfulSessionInterface
    private let notificationService: NotificationInterface
    
    init(hrvService: HealthKitInterface, mindfulService: MindfulSessionInterface, notificationManager: NotificationInterface) {
        self.hrvService = hrvService
        self.mindfulService = mindfulService
        self.notificationService = notificationManager
    }
    
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
            .padding(.top, 16)
            
            // TabView
            TabView(selection: $currentPage) {
                ExplainMenu().tag(0)
                BreathingGuide().tag(1)
                WatchGuide().tag(2)
                NotificationAuth().tag(3)
                HealthKitHRVAuth().tag(4)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            Button(action: {
                switch currentPage {
                case 3:
                    print("Request notification Authorization!")
                    isRequestingAuthorization = true
                    DispatchQueue.global(qos: .userInitiated).async {
                        notificationService.setupNotifications { success, error in
                                DispatchQueue.main.async {
                                    currentPage += 1
                                    isRequestingAuthorization = false
                                }
                        }
                    }
                case 4:
                    isRequestingAuthorization = true // 비동기 요청 시작
                    DispatchQueue.global(qos: .userInitiated).async {
                        hrvService.requestAuthorization { success, error  in
                            if success {
                                DispatchQueue.main.async {
                                    // 온보딩 완료 후 처리
                                    UserDefaults.standard.set(true, forKey: "hasLaunchedBefore") // 최초 실행 여부 저장
                                    self.router.backToMain()
                                    isRequestingAuthorization = false // 요청 완료
                                }
                            } else {
                                print("healthKit 권한 요청 실패")
                            }
                        }
                    }
                default:
                    currentPage += 1
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
            .disabled(isRequestingAuthorization) // 요청 중일 때 버튼 비활성화
            .animation(.easeInOut, value: isRequestingAuthorization) // 상태 변화 애니메이션 추가
            .padding(.horizontal, 8)
            .padding(.bottom, 16)
        }
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    OnboardingContainerView(hrvService: HealthKitManager(), mindfulService: MindfulSessionManager(), notificationManager: NotificationManager.shared)
}
