//
//  CrewHomeSheet.swift
//  RunUs
//
//  Created by 가은 on 12/11/24.
//

import SwiftUI

struct CrewHomeSheet: View {
    @Binding var selectedButtonIndex: Int?
    private let buttonText: [(image: String, text: String)] = [("edit","크루 정보 수정하기"), ("enter","가입 방식 변경하기"), ("trash","크루 삭제하기")]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            ForEach(Array(buttonText.enumerated()), id: \.offset) { index, item in
                button(image: item.image, contents: item.text, index: index)
            }
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func button(image: String, contents: String, index: Int) -> some View {
        Button {
            selectedButtonIndex = index
        } label: {
            HStack(spacing: 12) {
                Image(image)
                Text(contents)
                    .font(.body2_medium)
                    .foregroundStyle(image == "trash" ? .error : .secondaryGray)
                Spacer()
            }
        }
    }
}

#Preview {
    CrewHomeSheet(selectedButtonIndex: .constant(0))
}
