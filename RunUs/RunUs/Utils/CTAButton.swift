//
//  CTAButton.swift
//  RunUs
//
//  Created by 가은 on 12/3/24.
//

import SwiftUI

// CTA Bar에서 사용하는 버튼
// 좌우 padding은 따로 설정
struct CTAButton: View {
    let text: String
    @Binding var disabled: Bool
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Divider()
                .frame(height: 0.5)
                .background(.secondaryFill)
            Button(action: action) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(disabled ? .secondaryFill : .primary400)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                    Text(text)
                        .font(.title5_bold)
                        .foregroundStyle(.white)
                }
            }
            .disabled(disabled)
            .padding(.horizontal, 16)
            .padding(.bottom, 15)
        }
    }
}
