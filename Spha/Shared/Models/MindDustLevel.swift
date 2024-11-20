//
//  MindDustLevel.swift
//  Spha
//
//  Created by 지영 on 11/19/24.
//

import Foundation

enum MindDustLevel {
    case none   // 측정값이 없음
    case dustLevel1 // 깨끗한 상태
    case dustLevel2
    case dustLevel3
    case dustLevel4
    case dustLevel5
    
    /// 에셋 이름 반환
    var assetName: String {
        switch self {
        case .none:
            return FilePathHelper.none
        case .dustLevel1:
            return FilePathHelper.clean
        case .dustLevel2:
            return FilePathHelper.dirty01
        case .dustLevel3:
            return FilePathHelper.dirty02
        case .dustLevel4:
            return FilePathHelper.dirty03
        case .dustLevel5:
            return FilePathHelper.dirty04
        }
    }

    /// 상태 문구 반환
    var description: String {
        switch self {
        case .none:
            return "애플워치로 측정해주세요"
        case .dustLevel1:
            return "맑고 깨끗해요"
        case .dustLevel2:
            return "먼지가 조금 생겼어요"
        case .dustLevel3:
            return "점점 흐려져요"
        case .dustLevel4:
            return "탁하고 답답해요"
        case .dustLevel5:
            return "터질 것 같아요"
        }
    }
}
