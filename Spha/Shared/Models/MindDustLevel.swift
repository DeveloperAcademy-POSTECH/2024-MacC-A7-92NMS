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
            return NSLocalizedString("mind_dust_none", comment: "")
        case .dustLevel1:
            return NSLocalizedString("mind_dust_level1", comment: "")
        case .dustLevel2:
            return NSLocalizedString("mind_dust_level2", comment: "")
        case .dustLevel3:
            return NSLocalizedString("mind_dust_level3", comment: "")
        case .dustLevel4:
            return NSLocalizedString("mind_dust_level4", comment: "")
        case .dustLevel5:
            return NSLocalizedString("mind_dust_level5", comment: "")
        }
    }
}

