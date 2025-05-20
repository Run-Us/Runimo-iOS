//
//  CommonExtension.swift
//  Runimo
//
//  Created by 가은 on 4/14/25.
//

import Foundation
import SwiftUI
import UIKit

class CommonExtension {
    static func formatNumber(num: Int) -> String {
        if num >= 1000 {
            return String(format: "%.2fK", Double(num)/1000)
        }
        return String(num)
    }
    
    static func formatIntToKM(num: Int) -> String {
        if num >= 1000 {
            return String(format: "%.2fkm", Double(num)/1000)
        }
        return String(num)
    }
    
    static func triggerHaptic() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }
}

extension View {
    static var id: String { String(describing: Self.self) }
}
