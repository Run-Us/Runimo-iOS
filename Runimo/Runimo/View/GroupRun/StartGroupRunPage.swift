//
//  StartGroupRunPage.swift
//  RunUs
//
//  Created by byeoungjik on 9/16/24.
//

import SwiftUI

struct StartGroupRunPage: View {
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            Text("더 많은 기능이 기다리고 있어요!")
                .font(.title4_semibold)
                .foregroundStyle(.primaryGray)
            Text("친구와 함께 달리는 '그룹 달리기' 기능이 곧 출시됩니다")
                .font(.body2_medium)
                .foregroundStyle(.quaternaryGray)
            Spacer()
        }
    }
}

#Preview {
    StartGroupRunPage()
}
