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
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.title5_bold)
                .foregroundStyle(.white)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(.primary400)
                .cornerRadius(8)
        }
    }
}
