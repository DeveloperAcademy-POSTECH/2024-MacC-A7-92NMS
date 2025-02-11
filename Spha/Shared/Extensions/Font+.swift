//
//  Text+.swift
//  Spha
//
//  Created by 최하늘 on 11/20/24.
//

import SwiftUI

struct CustomFont {
    let font: Font
    let kerning: CGFloat
    let lineSpacing: CGFloat
    
    // title (0, 1)
    static let title_0 = CustomFont(font: .custom("AppleSDGothicNeoSB", size: 32), kerning: 0.4, lineSpacing: 32.0)
    static let title_1 = CustomFont(font: .custom("AppleSDGothicNeoSB", size: 30), kerning: 0.4, lineSpacing: 0.0)
    
    // body (0, 1)
    static let body_0 = CustomFont(font: .custom("AppleSDGothicNeoSB", size: 20), kerning: 0, lineSpacing: 20.0)
    static let body_1 = CustomFont(font: .custom("AppleSDGothicNeoR", size: 18), kerning: 0, lineSpacing: 18.0)
    
    // caption (0, 1, 2, 3, 4, 5)
    static let caption_0 = CustomFont(font: .custom("AppleSDGothicNeoR", size: 16), kerning: 0.4, lineSpacing: 16.0)
    static let caption_1 = CustomFont(font: .custom("AppleSDGothicNeoR", size: 14), kerning: -0.08, lineSpacing: 4.0)
    static let caption_2 = CustomFont(font: .custom("AppleSDGothicNeoR", size: 12), kerning: -0.08, lineSpacing: 4.0)
    static let caption_3 = CustomFont(font: .custom("AppleSDGothicNeoR", size: 8), kerning: -0.08, lineSpacing: 0.0)
    static let caption_4 = CustomFont(font: .custom("AppleSDGothicNeoR", size: 6), kerning: -0.08, lineSpacing: 6.0)
    static let caption_5 = CustomFont(font: .custom("AppleSDGothicNeoR", size: 5), kerning: -0.08, lineSpacing: 5.0)
    
    // 추가된 폰트
    static let caption_1_SB = CustomFont(font: .custom("AppleSDGothicNeoSB", size: 14), kerning: -0.08, lineSpacing: 8.0)
}

extension Text {
    func customFont(_ customFont: CustomFont) -> some View {
        self
            .font(customFont.font)
            .kerning(customFont.kerning)
            .lineSpacing(customFont.lineSpacing)
    }
}
