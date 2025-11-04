//
//  Int+Extension.swift
//  Runimo
//
//  Created by 가은 on 11/5/25.
//

import Foundation

extension Int {
    /// 미터를 km로 변환하여 포맷팅
    func toDistanceString() -> String {
        if self < 1000 { return "\(self)m"}
        
        let km = Double(self) / 1000.0
        let formatted = String(format: "%.2fkm", km)
        
        return formatted
    }
}
