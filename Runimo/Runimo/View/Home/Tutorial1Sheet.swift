//
//  Tutorial1Sheet.swift
//  Runimo
//
//  Created by 가은 on 7/2/25.
//

import SwiftUI

struct Tutorial1Sheet: View {
    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("달려서 알을 부화시켜봐요!")
                        .font(.title5_bold)
                        .foregroundStyle(.primaryGray)
                        .padding(.vertical, 16)
                    Spacer()
                }
                Text("""
                    • 주 1회 러닝만 해도 알 1개를 받아요
                    • 1km 달릴 때마다 애정을 1개씩 얻어요
                    """)
                    .font(.body2_medium)
                    .foregroundStyle(.tertiaryGray)
            }
            .padding(.horizontal, 20)
            
            Image("tutorial1")
            
            CTAButton(text: "다음", height: 44, disabled: false) {
                
            }
        }
    }
}

#Preview {
    Tutorial1Sheet()
}
