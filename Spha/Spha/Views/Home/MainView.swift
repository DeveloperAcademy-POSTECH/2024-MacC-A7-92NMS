import SwiftUI

struct MainView: View {
    @EnvironmentObject var router: RouterManager
    @StateObject private var viewModel = MainViewModel(HealthKitManager(), MindfulSessionManager())
    
    @State private var introOpacity = 0.0
    @State private var isFirstLaunch: Bool = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    
    var body: some View {
        ZStack {
            // 그라데이션 배경
            Color.backgroundGB
                .edgesIgnoringSafeArea(.all)
            
            // 메인 화면 요소
            VStack{
                HStack{
                    Spacer()
                    
                    Button {
                        router.push(view: .dailyStatisticsView)
                    } label: {
                        Image(systemName: "chart.bar.fill")
                            .resizable()
                            .frame(width: 28, height: 20)
                            .foregroundStyle(Color.buttonGraph)
                    }
                    .padding(.trailing, 8)
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
                
                Spacer()
                
                HStack{
                    Text("현재 마음구슬 상태")
                        .customFont(.caption_0)
                        .foregroundStyle(.white)
                    
                    Button {
                        router.push(view: .mainInfoView)
                    } label: {
                        Image(systemName: "info.circle")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundStyle(.white)
                    }
                    
                }
                
                Text("\(String(describing: viewModel.mindDustLvDescription))")
                    .customFont(.title_1)
                    .foregroundStyle(
                        viewModel.isHRVRecordedToday ?
                            .white : Color.gray0
                    )
                    .bold()
                    .padding(.top, 8)
                
                Spacer()
                
                MP4PlayerView(videoURLString: viewModel.mindDustLevel)
                    .frame(width: 300, height: 300)
                    .padding(.bottom, 16)
                
                
                HStack{
                    VStack{
                        HStack{
                            Text("\(viewModel.recommendedCount)")
                                .customFont(.title_0)
                                .foregroundStyle(.white)
                                .bold()
                            
                            Text("회")
                                .customFont(.caption_0)
                                .foregroundStyle(.white)
                                .bold()
                        }
                        .padding(.bottom, 2)
                        
                        Text("권장 청소 횟수")
                            .customFont(.caption_1)
                            .foregroundStyle(.gray)
                    }
                    
                    Rectangle()
                        .frame(width:1, height: 45)
                        .foregroundStyle(.gray)
                        .padding(.horizontal, 24)
                    
                    VStack{
                        HStack{
                            Text("\(viewModel.completedCount)")
                                .customFont(.title_0)
                                .foregroundStyle(.white)
                                .bold()
                            
                            Text("회")
                                .customFont(.caption_0)
                                .foregroundStyle(.white)
                                .bold()
                        }
                        .padding(.bottom, 2)
                        
                        Text("실행한 청소 횟수")
                            .customFont(.caption_1)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.bottom, 12)
                
                Spacer()
                
                Button {
                    viewModel.startBreathingIntro(router: router)
                } label: {
                    // 임시 버튼 라벨
                    Image("mainButton")
                        .resizable()
                        .frame(width: 90, height: 90)
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
            }
            
            // OnboardingStartView 오버레이
            if isFirstLaunch {
                OnboardingStartView()
                    .transition(.opacity) // 페이드 효과
                    .zIndex(1) // 항상 최상위에 위치
            }
            
            // BreathingIntroView 오버레이 뷰
            if viewModel.showBreathingIntro {
                Color.black
                    .opacity(viewModel.breathingIntroOpacity)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity) // Fade-in
            }
        }
        .onAppear {
            // Notification을 관찰하여 상태 초기화
            NotificationCenter.default.addObserver(forName: RouterManager.backToMainNotification, object: nil, queue: .main) { _ in
                viewModel.resetBreathingIntro()
            }
            
            if !isFirstLaunch {
                viewModel.updateTodayRecord()
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: RouterManager.backToMainNotification, object: nil)
        }
        .onChange(of: self.isFirstLaunch) { oldValue, newValue in
            viewModel.updateTodayRecord()
        }
    }
    
}

#Preview {
    MainView()
}
