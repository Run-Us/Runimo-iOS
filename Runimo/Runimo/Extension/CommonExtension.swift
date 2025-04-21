//
//  CommonExtension.swift
//  Runimo
//
//  Created by 가은 on 4/14/25.
//

import Foundation
import SwiftUI

class CommonExtension {
    static func formatNumber(num: Int) -> String {
        if num >= 1000 {
            return String(format: "%.2fK", Double(num)/1000)
        }
        return String(num)
    }
}

extension View {
    static var id: String { String(describing: Self.self) }
}
