//
//  AgreementTermsSheet.swift
//  Runimo
//
//  Created by 가은 on 5/19/25.
//

import SwiftUI

struct AgreementTermsSheet: View {
    @State private var agreeStatus: [Bool] = [false, false]

    var body: some View {
        VStack(alignment: .leading) {
            Text("약관 동의")
                .font(.title5_bold)
                .foregroundStyle(.primaryGray)
                .padding(.vertical, 16)

            VStack(spacing: 24) {
                item(title: "이용약관 동의 (필수)", index: 0)
                item(title: "개인정보 수집동의 (필수)", index: 1)
            }
        }
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func item(title: String, index: Int) -> some View {
        HStack(spacing: 12) {
            Button {
                agreeStatus[index].toggle()
            } label: {
                Image(agreeStatus[index] ? "checkbox_selected" : "checkbox")
                Text(title)
                    .font(.body1_bold)
                    .foregroundStyle(.secondaryGray)
            }
            .buttonStyle(.plain)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray400)
        }
    }
}

#Preview {
    AgreementTermsSheet()
}
