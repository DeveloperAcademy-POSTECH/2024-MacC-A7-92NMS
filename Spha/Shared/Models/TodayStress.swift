//
//  TodayStress.swift
//  Spha
//
//  Created by 지영 on 11/12/24.
//

import Foundation

struct TodayStress {
    var date: Date
    var recommendedReliefCount: Int
    var completedReliefCount: Int
    var skippedReliefCount: Int {
            return recommendedReliefCount - completedReliefCount
        }
}
