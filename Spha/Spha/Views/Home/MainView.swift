import SwiftUI

struct MainView: View {
    @EnvironmentObject var router: RouterManager
    @StateObject private var viewModel = MainViewModel()
    
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
                        
                    } label: {
                        Image(systemName: "chart.bar.fill")
                            .resizable()
                            .frame(width: 30, height: 25)
                            .foregroundStyle(.white)
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
                        
                    } label: {
                        Image(systemName: "info.circle")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundStyle(.white)
                    }

                }
                
                Text("\(viewModel.remainingCleaningCount.description)")
                    .customFont(.title_1)
                    .foregroundStyle(.white)
                    .bold()
                    .padding(.top, 8)
                
                Spacer()
                
                MP4PlayerView(videoURLString: viewModel.remainingCleaningCount.assetName)
                    .frame(width: 330, height: 330)
                
                Spacer()
                
                HStack{
                    VStack{
                        HStack{
                            Text("\(viewModel.recommendedCleaningCount)")
                                .customFont(.title_0)
                                .foregroundStyle(.white)
                                .bold()
                            
                            Text("회")
                                .customFont(.caption_0)
                                .foregroundStyle(.white)
                                .bold()
                        }
                        
                        Text("권장 청소 횟수")
                            .customFont(.caption_1)
                            .foregroundStyle(.gray)
                    }
                    
                    Rectangle()
                        .frame(width:1, height: 30)
                        .foregroundStyle(.gray)
                        .padding(.horizontal, 16)
                    
                    VStack{
                        HStack{
                            Text("\(viewModel.actualCleaningCount)")
                                .customFont(.title_0)
                                .foregroundStyle(.white)
                                .bold()
                            
                            Text("회")
                                .customFont(.caption_0)
                                .foregroundStyle(.white)
                                .bold()
                        }
                        Text("실행한 청소 횟수")
                            .customFont(.caption_1)
                            .foregroundStyle(.gray)
                    }
                }
                
                Spacer()
                
                Button {
                    viewModel.startBreathingIntro()
                } label: {
                    // 임시 버튼 라벨
                    Image(systemName: "archivebox.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(.gray)
                }

                
                Spacer()
                
            }
            
            // BreathingIntroView 오버레이 뷰
            if viewModel.showBreathingIntro {
                VStack {
                }
                .navigationBarBackButtonHidden()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .opacity(viewModel.breathingIntroOpacity) // 페이드인 효과
                .onAppear {
                    withAnimation(.easeIn(duration: 1.0)) {
                        viewModel.breathingIntroOpacity = 1.0
                    }
                    // 일정 시간 후 다른 화면으로 이동
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        router.push(view: .breathingMainView)
                    }
                }
            }
            
        } // ZStack
        .onAppear {
            // Notification을 관찰하여 상태 초기화
            NotificationCenter.default.addObserver(forName: RouterManager.backToMainNotification, object: nil, queue: .main) { _ in
                viewModel.resetBreathingIntro()
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: RouterManager.backToMainNotification, object: nil)
        }
    }
    
}

#Preview {
    MainView()
}
