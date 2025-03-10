//
//  StressLevel.swift
//  Spha
//
//  Created by 지영 on 11/12/24.
//

import Foundation

enum StressLevel: String, CaseIterable {
    case low
    case medium
    case high
    case extreme
    
    var title: String {
        switch self {
        case .low:    // hrv >= 55
            return NSLocalizedString("stress_level_low", comment: "훌륭함")
        case .medium: // 45< hrv <55
            return NSLocalizedString("stress_level_medium", comment: "정상")
        case .high:   // 30< hrv <44
            return NSLocalizedString("stress_level_high", comment: "주의필요")
        case .extreme: // hrv<=30
            return NSLocalizedString("stress_level_extreme", comment: "과부하")
        }
    }
    
    var numberValue: Double {
        switch self {
        case .low: return 0
        case .medium: return 1
        case .high: return 2
        case .extreme: return 3
        }
    }
    
    // TODO: 원시값으로 수정
    static func getLevel(from hrvValue: Double) -> StressLevel {
        switch hrvValue {
        case 55...:
            return .low       // 훌륭함
        case 45..<55:
            return .medium    // 정상
        case 30..<45:
            return .high      // 주의필요
        default: // hrvValue <= 30
            return .extreme   // 과부하
        }
    }
}
