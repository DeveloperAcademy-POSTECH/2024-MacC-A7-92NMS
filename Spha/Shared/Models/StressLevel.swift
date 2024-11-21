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
        case .low:
            "과부하"
        case .medium:
            "주의필요"
        case .high:
            "정상"
        case .extreme:
            "훌륭함"
        }
    }
    
    var numberValue: Double {
        switch self {
        case .low: return 3
        case .medium: return 2
        case .high: return 1
        case .extreme: return 0
        }
    }
}
