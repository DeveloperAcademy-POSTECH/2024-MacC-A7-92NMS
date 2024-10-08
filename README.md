# 2024-MacC-A7-92NMS

# 👩🏻‍💻 애플 기기만을 위한 디지털 오브제 
- 배포 URL : https://
- Test ID : @test.com
- Test PW : 

## 👨‍🏫 프로젝트 소개 Project Overview
- "애플 기기간의 연속성을 기반으로 한 디지털 오브제"를 주제로 한 애플리케이션입니다.
- Multipeer Connectivity를 통해 애플 기기간의 통신할 수 있습니다.
- 테마를 선택하여 화면 디스플레이 간의 연속 엔티티 요소를 확인할 수 있습니다.
- 화면 디스플레이 내에서 사용자 인터렉션을 할 수 있습니다.
<br>

## ✋ 팀원 구성 Team Members

<div align="center">

| **구름** | **이수** | **앤드류** | **밀루** | **세이디** |
| :------: |  :------: | :------: | :------: |
| <img src="" alt="구름" width="150"> | <img src="" alt="이수" width="150"> | <img src="" alt="앤드류" width="150"> | <img src="" alt="밀루" width="150"> | <img src="" alt="세이디" width="150"> |
| Design | Design | Dev | Dev | Dev |
| [GitHub](https://github.com/) | [GitHub](https://github.com/) | [GitHub](https://github.com/) | [GitHub](https://github.com/) | [GitHub](https://github.com/) |
</div>

<br>

##  🕺🏻 Technology Stack
## 1. 개발 환경 

<img src="https://img.shields.io/badge/Swift-FA7343?style=flat&logo=Swift&logoColor=white"/> <img src="https://img.shields.io/badge/SwiftUI-FA7343?style=flat&logo=Swift&logoColor=white"/> <img src="https://img.shields.io/badge/CoreData-FA7343?style=flat&logo=Swift&logoColor=white"/> <img src="https://img.shields.io/badge/XCode-147EFB?style=flat&logo=XCode&logoColor=white"/> <img src="https://img.shields.io/badge/Git-F05032?style=flat&logo=Git&logoColor=white"/>


- Language : Swift
- 버전 및 이슈관리 : Github, Github Issues, Github Project
- 협업 툴 : Notion, Miro, Discord, Teams
- 서비스 배포 환경 : 
- 디자인 : [Figma](https://www.figma.com/)
- [커밋 컨벤션]
- [코드 컨벤션]
<br>

## 2. 채택한 개발 기술과 브랜치 전략
### Multipeer Connectivity
- 애플 기기간의 연속성을 고려하여 기본 프레임워크를 통한 통신을 선택하였습니다.
- 컴포넌트화를 통해 추후 유지보수와 재사용성을 고려했습니다.

### 브랜치 전략
- Git-flow 전략을 기반으로 main, develop 브랜치와 feature 보조 브랜치를 운용했습니다.
- main, develop, Feat 브랜치로 나누어 개발을 하였습니다.
    - **main** 브랜치는 배포 단계에서만 사용하는 브랜치입니다.
    - **develop** 브랜치는 개발 단계에서 git-flow의 master 역할을 하는 브랜치입니다.
    - **Feat** 브랜치는 기능 단위로 독립적인 개발 환경을 위하여 사용하고 merge 후 각 브랜치를 삭제해주었습니다.

<br>

# 3. 주요 기능 Key Features
- **장치 연결 설정**:
  - multipeer connectivity로 장치간 연결을 설정합니다.

- **테마 설정**:
  - 테마를 선택하여 디지털 오브제 화면설정 및 인터렉션을 수행합니다.

- **기타**:
  - 레이아웃 설정

<br>

## 4. 프로젝트 구조 Project Foldering
```plaintext
SwiftUI Foldering
│
├─ Resources
│	 ├─ Assets
│	 ├─ Preview Content
│	 └─ Extensions
├─ Sources
│	 ├─ Models
│	 ├─ Managers
│	 ├─ Views
│  │  ├─ ContentView.swift
│	 └─ Protocols
```
## 5. 역할 분담 Tasks & Responsibilities

<div align="center">

| **구름** | **이수** | **앤드류** | **밀루** | **세이디** |
| :------: |  :------: | :------: | :------: |
| <img src="" alt="구름" width="150"> | <img src="" alt="이수" width="150"> | <img src="" alt="앤드류" width="150"> | <img src="" alt="밀루" width="150"> | <img src="" alt="세이디" width="150"> |
|- **UI**
    - 페이지 : 홈, 검색, 게시글 작성, 게시글 수정, 게시글 상세, 채팅방
    - 공통 컴포넌트 : 게시글 템플릿, 버튼 | Design | Dev | Dev | Dev |
| - **기능**
    - 유저 검색, 게시글 등록 및 수정, 게시글 상세 확인, 댓글 등록, 팔로워 게시글 불러오기, 좋아요 기능
 | [GitHub](https://github.com/) | [GitHub](https://github.com/) | [GitHub](https://github.com/) | [GitHub](https://github.com/) |
</div>


## 6. 개발 기간 및 작업 관리

### 개발 기간

- 전체 개발 기간 : 2024-
- UI 구현 : 2024-10-08 ~ 2024-10-
- 기능 구현 : 2024
<br>

### 작업 관리

- GitHub Projects와 Issues를 사용하여 진행 상황을 공유했습니다.
- 주간회의를 진행하며 작업 순서와 방향성에 대한 고민을 나누고 Miro, Notion에 회의 내용을 기록했습니다.

###  1) 코드 컨벤션

###  2) 커밋 컨벤션

###  3) 리뷰 컨벤션

<br>

## 7. 페이지별 기능
## 8. 개선 목표

- 테마 모듈화 및 프로토콜 관리 :테마 별 반복되는 정보 및 애니메이션 요소 관리

- **성능 개선 내용**

    - 이미지 최적화 및 gif
    - 레이아웃 및 기기 최적화
    
<br>


