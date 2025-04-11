//
//  SessionTab.swift
//  RunUs
//
//  Created by 가은 on 12/4/24.
//

import SwiftUI

enum RunningPace: String {
    case above500 = "ABOVE_500"
    case pace500 = "500"
    case pace530 = "530"
    case pace600 = "600"
    case pace630 = "630"
    case pace700 = "700"
    case pace730 = "730"
    case pace800 = "800"
    case fastWalk = "FAST_WALK"
    
    var description: String {
        switch self {
        case .above500: return "5’00” 이하"
        case .fastWalk: return "빠른 걸음"
        default: return "\(self.rawValue.dropLast(2))’\(self.rawValue.dropFirst())”"
        }
    }
}

struct SessionTab: View {
    @State private var selectedDateIndex: Int = 0
    @State private var showSessionDetailPage: Bool = false
    
    var body: some View {
        ZStack {
            Color.primaryBG.ignoresSafeArea()
            VStack(spacing: 8) {
                Text("더 많은 기능이 기다리고 있어요!")
                    .font(.title4_semibold)
                    .foregroundStyle(.primaryGray)
                Text("친구와 함께 달리는 '모임' 기능이 곧 출시됩니다")
                    .font(.body2_medium)
                    .foregroundStyle(.quaternaryGray)
            }
        }
    }
}

#Preview {
    SessionTab()
}
