//
//  InputTextArea.swift
//  RunUs
//
//  Created by 가은 on 12/4/24.
//

import SwiftUI

struct InputTextArea: View {
    let title: String
    let placeholder: String
    let maxCount: Int
    @Binding var contents: String
    let height: CGFloat
    @FocusState var isEditorFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !title.isEmpty {
                Text(title)
                    .font(.body1_bold)
                    .foregroundStyle(.secondaryGray)
            }
            ZStack(alignment: .topLeading) {
                // input text
                TextEditor(text: Binding(get: { contents }, set: { newValue in
                    if newValue.count <= maxCount {
                        contents = newValue
                    } else {
                        contents = String(newValue.prefix(maxCount))
                    }
                }))
                .scrollContentBackground(.hidden)
                .focused($isEditorFocused)
                .font(.body2_medium)
                .padding(8)
                .frame(height: height)
                .foregroundColor(.primaryGray)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke($contents.wrappedValue.count > 0 ? .secondaryGray : .secondaryFill)
                )
                // placeholder
                if $contents.wrappedValue.isEmpty {
                    Text(placeholder)
                        .font(.body2_medium)
                        .foregroundStyle(.gray400)
                        .padding(EdgeInsets(top: 15, leading: 12, bottom: 15, trailing: 12))
                }
            }

            // 글자수
            HStack {
                Spacer()
                Text("\($contents.wrappedValue.count)/\(maxCount)")
                    .foregroundStyle(.gray400)
                    .font(.caption_regular)
            }
        }
        .padding(.horizontal, 1)
    }
}
