import SwiftUI

struct MainView: View {
    @EnvironmentObject var router: RouterManager
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject private var viewModel = MainViewModel(HealthKitManager(), MindfulSessionManager())
    
    @State private var introOpacity = 0.0
    @State private var isFirstLaunch: Bool = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    @State private var isBreathingViewPresented = false
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            // 그라데이션 배경
            Color.backgroundGB
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
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
                    .padding(.top, 32)
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
                        isBreathingViewPresented.toggle()
                    } label: {
                        // 임시 버튼 라벨
                        Image("mainButton")
                            .resizable()
                            .frame(width: 90, height: 90)
                            .foregroundStyle(.gray)
                    }
                    .padding(.top, 48)
                }
            }
            .refreshable {
                triggerRefresh()
            }
            
            // OnboardingStartView 오버레이
            if isFirstLaunch {
                OnboardingStartView()
                    .transition(.opacity) // 페이드 효과
                    .zIndex(1) // 항상 최상위에 위치
            }
            
            // 로딩 중 프로그레스 바
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle()).foregroundColor(.white)
                    .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
            }
        }
        .sheet(isPresented: $isBreathingViewPresented) {
            BreathingMainView(breathManager: BreathingMainViewModel())
        }
        .onAppear {
            if !isFirstLaunch {
                viewModel.updateTodayRecord()
            }
        }
        .onChange(of: self.isFirstLaunch) { oldValue, newValue in
            viewModel.updateTodayRecord()
        }
        .onChange(of: scenePhase) { _, newPhase in // 추가: 앱 상태 변화 감지
            if newPhase == .active { // 포그라운드로 복귀 시
                viewModel.updateTodayRecord()
            }
        }
    }
    
    private func triggerRefresh() {
        // 햅틱 발생
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // 로딩 상태 활성화
        isLoading = true
        
        // 데이터 업데이트 실행
        viewModel.updateTodayRecord()
        
        // 로딩 상태 비활성화 (딜레이 시뮬레이션)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
        }
    }
}

#Preview {
    MainView()
}
