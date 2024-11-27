//
//  DailyStressRecord.swift
//  Spha
//
//  Created by 지영 on 11/21/24.
//

import Foundation

struct DailyStressRecord: Hashable {
    var date: Date
    var recommendedReliefCount: Int
    var completedReliefCount: Int
    var skippedReliefCount: Int {
            return recommendedReliefCount - completedReliefCount
        }
    
    var mindDustLevel: MindDustLevel {
        if skippedReliefCount <= 0 {
            return .dustLevel1
        }
        
        switch skippedReliefCount {
        case 1:
            return .dustLevel2
        case 2:
            return .dustLevel3
        case 3:
            return .dustLevel4
        default:
            return .dustLevel5
        }
    }
}
