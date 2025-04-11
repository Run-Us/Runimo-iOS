//
//  SessionTab.swift
//  RunUs
//
//  Created by 가은 on 12/4/24.
//

import SwiftUI

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
