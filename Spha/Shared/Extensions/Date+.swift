//
//  Date+.swift
//  Spha
//
//  Created by 지영 on 11/15/24.
//

import Foundation

extension Date {
    /// 달력에 필요한 요일 문자열 반환
    var dayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "E"
        return formatter.string(from: self).uppercased()
    }
    
    /// 달력에 필요한 날짜 문자열 반환
    var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: self)
    }
}
