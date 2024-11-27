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
}
