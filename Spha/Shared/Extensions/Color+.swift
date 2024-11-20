//
//  Color+.swift
//  Spha
//
//  Created by 최하늘 on 11/20/24.
//

import SwiftUI

extension Color {
    // 단일 컬러
    static let customBlack = Color(red: 0.06, green: 0.06, blue: 0.06)
    static let gray0 = Color(red: 0.56, green: 0.56, blue: 0.56)
    static let gray1 = Color(red: 0.38, green: 0.38, blue: 0.38)
    static let gray2 = Color(red: 0.2, green: 0.2, blue: 0.2)
    static let buttonSquare = Color(red: 0.95, green: 0.95, blue: 0.95).opacity(0.1)
    
    // 그라데이션 컬러
    static var backgroundGB: LinearGradient {
        LinearGradient(
            stops: [
                Gradient.Stop(color: .black, location: 0.61),
                Gradient.Stop(color: Color(red: 0.19, green: 0.19, blue: 0.19).opacity(0.5), location: 0.77),
                Gradient.Stop(color: Color(red: 0.38, green: 0.38, blue: 0.38).opacity(0), location: 0.97),
            ],
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 1.12)
        )
    }
    
    static var buttonGraph: LinearGradient {
        LinearGradient(
            stops: [
                Gradient.Stop(color: .white, location: 0.00),
                Gradient.Stop(color: Color(red: 0.6, green: 0.6, blue: 0.6), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 1)
        )
    }
    
    static var graphButtonColor: LinearGradient {
        LinearGradient(
            stops: [
                Gradient.Stop(color: .white, location: 0.00),
                Gradient.Stop(color: Color(red: 0.6, green: 0.6, blue: 0.6), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 1)
        )
    }
    
    static var gcStroke: LinearGradient {
        LinearGradient(
            stops: [
                Gradient.Stop(color: .white.opacity(0.9), location: 0.00),
                Gradient.Stop(color: .white.opacity(0.2), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 1)
        )
    }
    
    static var gcFill: EllipticalGradient {
        EllipticalGradient(
            stops: [
                Gradient.Stop(color: .white.opacity(0.2), location: 0.08),
                Gradient.Stop(color: Color(red: 0.85, green: 0.85, blue: 0.85), location: 1.00),
            ],
            center: UnitPoint(x: 0.5, y: 0.5)
        )
    }
}
