//
//  TodayStress.swift
//  Spha
//
//  Created by 지영 on 11/12/24.
//

import Foundation
import SwiftUI

struct TodayStress: Hashable {
    var date: Date
    var color: Color
    var recommendedReliefCount: Int
    var completedReliefCount: Int
    var skippedReliefCount: Int {
            return recommendedReliefCount - completedReliefCount
        }
}
