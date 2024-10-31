//
//  MyPageViewModel.swift
//  RunUs
//
//  Created by 가은 on 10/31/24.
//

import Foundation

enum RecordType {
    case weekly, monthly, yearly
}

class MyPageViewModel: ObservableObject {
    @Published var selectedTab: Int = 0
    
    var recordType: RecordType {
        switch (selectedTab) {
        case 0: return .weekly
        case 1: return .monthly
        default: return .yearly
        }
    }
    
    var xData: [String] {
        switch (recordType) {
        case .weekly:
            return ["월","화","수","목","금","토","일"]
        case .monthly:
            return [6,13,20,27].map{String($0)}
        case .yearly:
            return Array(1...12).map{String($0)}
        }
    }
}
