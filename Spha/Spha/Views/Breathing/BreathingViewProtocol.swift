//
//  BreathingViewProtocol.swift
//  Spha
//
//  Created by 추서연 on 11/20/24.
//

import SwiftUI

protocol BreathingViewProtocol: View {
    associatedtype Content: View
    var viewModel: BreathingViewModel { get }
    var customContent: Content { get }
}
