# 2024-MacC-A7-92NMS
**숨쉴수록 맑아지는 나의 마음, Spha와 함께 스트레스를 관리하세요!**

# 🌬️ Spha : Your escape from stress
[Spha 바로가기](https://apps.apple.com/kr/app/spha/id6738649249)
[Spha 자세히 보기](https://tarry-shoulder-2e9.notion.site/Spha-6ee0c783d21d474f97960439efc0e09f)


---

### 🔮 프로젝트 소개 (Project Overview)
**"숨을 쉬며 마음을 청소하고, 더 평온한 하루를 시작하세요."**



Spha는 Apple Watch의 **HRV 데이터(심박 변이도)** 를 실시간으로 분석하여 스트레스 상태를 시각화하고, 간단한 **박스 호흡법(Box Breathing)** 으로 마음을 가라앉히도록 돕는 애플리케이션입니다.  
애플워치의 HRV 데이터를 통해 실시간으로 스트레스 상태를 확인하고, 박스 호흡법으로 마음을 가라앉힐 수 있도록 도와줍니다. 하루 동안 쌓인 스트레스 먼지를 말끔히 청소하고, 평온하고 가벼운 마음으로 새로운 하루를 시작하세요. **우리 한번 습-하💨 해봐요. Find your calm. Take a deep Spha.**

- **스트레스 시각화**: 스트레스를 "마음 구슬"로 표현해 직관적인 상태 확인
- **실시간 스트레스 해소**: 과부하 상태에서는 즉각적인 호흡 권장
- **장기적 관리**: 일일 및 월별 스트레스 변화 통계 제공

---

### ✋ 팀원 구성 (Team Members)

| 구름 | 이수 | 앤드류 | 밀루 | 세이디 |
|:------:|:------:|:------:|:------:|:------:|
| <img src="" alt="구름" width="150"> | <img src="" alt="이수" width="150"> | <img src="" alt="앤드류" width="150"> | <img src="" alt="밀루" width="150"> | <img src="" alt="세이디" width="150"> |
| Design | Design | Dev | Dev | Dev |
| [GitHub](https://github.com/) | [GitHub](https://github.com/) | [GitHub](https://github.com/) | [GitHub](https://github.com/) | [GitHub](https://github.com/) |


---




### 🌟 주요 기능 (Key Features)

#### 1️⃣ 심박수 기반 실시간 스트레스 관리
- Apple Watch에서 HRV 데이터를 불러와 **과부하**, **주의 필요**, **정상**, **훌륭함** 네 가지 상태로 분류
- 과부하 상태 시 즉시 호흡 권장 알림 제공

#### 2️⃣ 박스 호흡법을 통한 스트레스 완화
- 1분 동안 **들이마시기 - 멈추기 - 내쉬기 - 멈추기**를 반복하며 마음을 진정
- 스트레스가 해소될 때마다 마음 구슬의 먼지가 제거되는 시각적 피드백 제공

#### 3️⃣ 통계와 그래프로 장기적 관리
- **일일 통계**: 하루 동안의 스트레스 변화 그래프 확인
- **월별 통계**: 캘린더 형태로 스트레스 추이와 마음 구슬 상태 변화 기록
- 애플 건강 앱의 **마음챙기기 시간**에 호흡 데이터 연동

#### 4️⃣ 마음 구슬 (Stress Visualization)
- 스트레스 상태를 시각화해 사용자가 즉각적인 심리적 변화를 확인 가능
- 구슬의 상태 변화로 호흡 관리 필요성 직관적 전달

---

### 🚀 앱 작동 방식 (How It Works)
1. Apple Watch에서 실시간 HRV 데이터를 수집
2. 앱이 HRV를 분석해 스트레스 상태를 분류
3. 과부하 상태 감지 시 호흡법 실행 권장 알림
4. 사용자가 호흡을 진행하면 마음 구슬 상태가 청소되며 스트레스 완화
5. 모든 데이터는 Apple HealthKit과 연동하여 장기적 관리 가능

---

### 🔐 권한 요청 (Permissions)
원활한 앱 사용을 위해 아래 접근 권한이 필요합니다:
- **알림 권한**: 스트레스 관리 및 호흡 권장 알림
- **HealthKit 접근 권한**: HRV 데이터 및 마음챙기기 시간 연동  
※ 선택적 권한 거부 시 일부 기능 제한될 수 있습니다.

---

###  🛠️ 기술 스택 (Technology Stack)
#### 1. 개발 환경 

<img src="https://img.shields.io/badge/Swift-FA7343?style=flat&logo=Swift&logoColor=white"/> <img src="https://img.shields.io/badge/SwiftUI-FA7343?style=flat&logo=Swift&logoColor=white"/> <img src="https://img.shields.io/badge/CoreData-FA7343?style=flat&logo=Swift&logoColor=white"/> <img src="https://img.shields.io/badge/XCode-147EFB?style=flat&logo=XCode&logoColor=white"/> <img src="https://img.shields.io/badge/Git-F05032?style=flat&logo=Git&logoColor=white"/>


- **Language**: SwiftUI
- **Frameworks**: HealthKit
- **Version Control**: Git, GitHub
- **Collaboration Tools**: Notion, Figma, Miro, Discord
- **Project Management**: GitHub Issues, GitHub Projects
- **Design**: Figma

#### 2. 채택 개발 기술과 브랜치 전략

### 브랜치 전략
- Git-flow 전략을 기반으로 main, develop 브랜치와 feature 보조 브랜치를 운용했습니다.
- main, develop, Feat 브랜치로 나누어 개발을 하였습니다.
    - **main** 브랜치는 배포 단계에서만 사용하는 브랜치입니다.
    - **develop** 브랜치는 개발 단계에서 git-flow의 master 역할을 하는 브랜치입니다.
    - **Feat** 브랜치는 기능 단위로 독립적인 개발 환경을 위하여 사용하고 merge 후 각 브랜치를 삭제해주었습니다.


#### 3. 프로젝트 구조 (Project Foldering)
```
Spha/
├─ Shared
│   ├─ Resources
│   │   ├─ MP4
│   │   └─ Font
│   │       ├─ AppleSDGothicNeoM.ttf
│   │       ├─ AppleSDGothicNeoSB.ttf
│   │       └─ AppleSDGothicNeoR.ttf
│   ├─ Managers
│   │   ├─ MindfulSessionManager
│   │   │   ├─ MindfulSessionManager.swift
│   │   │   └─ MindfulSessionTestView
│   │   │       └─ MindfulSessionTestView.swift
│   │   ├─ HealthKitManager
│   │   │   ├─ HealthKitManager.swift
│   │   │   └─ AppDelegate.swift
│   │   ├─ NotificationManager.swift
│   │   ├─ RouterManager.swift
│   │   └─ BreathingManager.swift
│   ├─ Models
│   │   ├─ DailyStressRecord.swift
│   │   ├─ BreathingPhase.swift
│   │   ├─ MindDustLevel.swift
│   │   └─ StressLevel.swift
│   ├─ Extensions
│   │   ├─ Color+.swift
│   │   ├─ Date+.swift
│   │   └─ Font+.swift
│   └─ Helper
│       └─ FilePathHelper.swift
├─ Spha
│   ├─ Managers
│   │   └─ HealthKitManager+iOS.swift
│   ├─ Assets.xcassets
│   ├─ Views
│   │   ├─ Statistics
│   │   │   ├─ DailyStatisticsViewModel.swift
│   │   │   └─ DailyStatisticsView.swift
│   │   ├─ Home
│   │   │   ├─ MP4PlayerView.swift
│   │   │   ├─ MainInfoView.swift
│   │   │   ├─ MainViewModel.swift
│   │   │   └─ MainView.swift
│   │   ├─ Breathing
│   │   │   ├─ BreathingMainViewModel.swift
│   │   │   ├─ BreathingMainView.swift
│   │   │   ├─ BreathingOutroViewModel.swift
│   │   │   └─ BreathingOutroView.swift
│   │   ├─ Onboarding
│   │   │   ├─ IndicatorViews
│   │   │   │   ├─ WatchGuide.swift
│   │   │   │   ├─ ExplainMenu.swift
│   │   │   │   ├─ HealthKitHRVAuth.swift
│   │   │   │   ├─ BreathingGuide.swift
│   │   │   │   └─ NotificationAuth.swift
│   │   │   ├─ OnboardingStartView.swift
│   │   │   └─ OnboardingContainerView.swift
│   │   └─ ContentView.swift
│   └─ SphaApp.swift
└─ SphaWatch Watch App
    ├─ Notification
    │   ├─ PushNotificationPayload.apns
    │   └─ NotificationView.swift
    ├─ Manager
    │   ├─ HapticManager.swift
    │   └─ WatchRouterManager.swift
    └─ Views
        ├─ Home
        │   ├─ WatchMainStatusViewModel.swift
        │   ├─ WatchMainView.swift
        │   └─ WatchMainStatusView.swift
        └─ Breathing
            ├─ WatchBreathingExitView.swift
            ├─ WatchBreathingMainView.swift
            ├─ WatchBreathingMainViewModel.swift
            ├─ WatchBreathingOutroViewModel.swift
            ├─ WatchBreathingMP4PlayerView.swift
            ├─ WatchBreathingSelectionView.swift
            └─ WatchBreathingOutroView.swift
    └─ SphaWatchApp.swift


```

#### 4. 역할 분담 (Tasks & Responsibilities)

| 구름 | 이수 | 앤드류 | 밀루 | 세이디 |
|:------:|:------:|:------:|:------:|:------:|
| <img src="" alt="구름" width="150"> | <img src="" alt="이수" width="150"> | <img src="" alt="앤드류" width="150"> | <img src="" alt="밀루" width="150"> | <img src="" alt="세이디" width="150"> |
| - **UI** | - **UI** | - **기능** | - **기능** | - **기능** |
| - 페이지 : 홈, 검색, 테마 선택, 레이아웃, 테마 인터렉션 | - 페이지 : 홈, 검색, 테마 선택, 레이아웃, 테마 인터렉션 | - 테마 검색, 레이아웃 수정, 애니메이션 로직 | - 테마 검색, 레이아웃 수정, 애니메이션 로직 | - 스트레스 관리 기능, 애플 워치 연동 |
| - 공통 컴포넌트 : 애니메이션 로직, 버튼 | - 공통 컴포넌트 : 애니메이션 로직, 버튼 | - 애플 건강 앱 연동, HRV 데이터 연동 | - 통계 화면 데이터 연결, 호흡 알림 로직 | - 애플 워치 데이터 처리, UI 최적화 |



#### 5. 개발 기간 및 작업 관리

### 개발 기간

- 전체 개발 기간 : 2024-11-14 ~ 2024-11-24
- 기능 구현 : 2024-11-14 ~ 2024-11-17
- UI 구현 : 2024-11-18 ~ 2024-11-24

---


### 📝 작업 관리

- GitHub Projects와 Issues를 사용하여 진행 상황을 공유했습니다.
- 주간회의를 진행하며 작업 순서와 방향성에 대한 고민을 나누고 Miro, Notion, Figma에 회의 내용을 기록했습니다.

####  1. 코드 컨벤션
https://github.com/DeveloperAcademy-POSTECH/swift-style-guide

####  2. 커밋 컨벤션
● [작업] #이슈번호-커밋제목
Chore: #1-그냥 보통 잡일
Feat: #1-새로운 주요 기능 추가
Add: #2-파일 추가, 에셋 추가, etc
Fix: #2-버그 수정
Del: #2-쓸모없는 코드, 뭐 어쩌고 삭제
Refactor: #2-코드 리팩토링 -> 결과는 똑같음. 근데 코드가 달라짐
Move: #2-프로젝트 구조 변경(폴더링 등)
Rename: #2-파일, 클래스, 변수명 등 이름 변경
Docs: #2-Wiki, README 파일 수정


####  3. 리뷰 컨벤션

#####  **코드 리뷰 (24시간 이내)**

- **코드 리뷰 시간**: 모든 Pull Request(P.R)는 **24시간 이내에 코드 리뷰 완료**.
- **리뷰어 배정**: 최소 **두 명 이상의 리뷰어**가 코드를 확인하고 피드백을 제공.
- **피드백 반영**: 피드백을 반영한 후, **수정된 코드에 대해 빠른 재검토**와 승인을 받음.
- **긴급한 경우**: 코드 리뷰가 24시간 이내에 이루어지지 않으면 **팀 리더 또는 프로젝트 매니저에게 알림**.
- **승인 기준**: **두 명 이상의 리뷰어** 승인을 받은 후 머지 가능.

##### 추가 사항
- **지속적인 코드 품질**: **코드 표준** 준수, 코드 스타일 및 네이밍 규칙 점검.
- **성능 및 보안 점검**: 성능과 보안에 영향을 미칠 수 있는 변경 사항에 대해 **세밀하게 검토**.
- **코드 리뷰 문화**: **협업과 학습**의 기회로, 건설적이고 구체적인 피드백을 주고받음.

---

### 🎉 성능 개선 목표

- 테마 모듈화 및 프로토콜 관리 :테마 별 반복되는 정보 및 애니메이션 요소 관리
- 이미지 및 비디오 최적화

---


**🌬️ 오늘도 Spha와 함께 스트레스를 비우고, 가벼운 마음으로 하루를 시작하세요! 습-하! Stress less, Spha more**
