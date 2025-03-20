//
//  TypeCheckbox.swift
//  RunUs
//
//  Created by 가은 on 12/3/24.
//

import SwiftUI

struct TypeCheckbox: View {
    let selectedBox: Int    // 선택된 박스 idx
    let typeIdx: Int        // 현재 박스 idx
    let title: String
    let explanation: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(typeIdx == selectedBox ? "checkbox_selected" : "checkbox")
                .resizable()
                .frame(width: 20, height: 20)
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.body1_bold)
                    .foregroundStyle(.secondaryGray)
                Text(explanation)
                    .font(.caption_regular)
                    .foregroundStyle(.quaternaryGray)
            }
        }
        .padding(.top, 32)
    }
}
