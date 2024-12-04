//
//  SessionTab.swift
//  RunUs
//
//  Created by 가은 on 12/4/24.
//

import SwiftUI

struct SessionTab: View {
    var body: some View {
        ZStack {
            Color.primaryBG.ignoresSafeArea()
            VStack {
                navigationBar()
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private func navigationBar() -> some View {
        VStack(spacing: 0) {
            HStack {
                Text("러닝세션 찾기")
                    .font(.title5_bold)
                Spacer()
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 14, height: 14)
            }
            .foregroundStyle(.primaryGray)
            .padding(16)
            Divider()
        }
    }
}

#Preview {
    SessionTab()
}
