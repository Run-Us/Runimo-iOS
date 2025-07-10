//
//  AgreementTermsSheet.swift
//  Runimo
//
//  Created by 가은 on 5/19/25.
//

import SwiftUI

struct AgreementTermsSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var callSignUp: Bool
    @State private var agreeStatus: [Bool] = [false, false]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("약관 동의")
                .font(.title5_bold)
                .foregroundStyle(.primaryGray)
                .padding(.vertical, 16)
                .padding(.horizontal, 20)

            VStack(spacing: 24) {
                item(title: "이용약관 동의 (필수)", index: 0, url: "https://runimo-blog.vercel.app/posts/terms-service")
                item(title: "개인정보 수집동의 (필수)", index: 1, url: "https://runimo-blog.vercel.app/posts/privacy-policy")
//                item(title: "광고성 정보 수신동의 (선택)", index: 2, url: "https://runimo-blog.vercel.app/posts/marketing-policy")
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            CTAButton(text: "시작하기", disabled: allSelected()) {
                callSignUp = agreeStatus[0] && agreeStatus[1]
                dismiss()
            }
            .padding(.top, 12)
        }
        .padding(.vertical, 8)
        .background(.primaryFill)
    }

    @ViewBuilder
    private func item(title: String, index: Int, url: String) -> some View {
        HStack(alignment: .top) {
            Button {
                agreeStatus[index].toggle()
            } label: {
                HStack(alignment: .top, spacing: 12) {
                    Image(agreeStatus[index] ? "checkbox_selected" : "checkbox")
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.body1_bold)
                            .foregroundStyle(.secondaryGray)
                        if index == 2 {
                            Text("다양한 프로모션 소식 및 신규 예정 정보를 보내드려요.")
                                .font(.caption_regular)
                                .foregroundStyle(.quaternaryGray)
                        }
                    }
                }
            }
            .buttonStyle(.plain)
            Spacer()
            
            Link(destination: URL(string: url)!) {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray400)
            }
        }
    }
    
    private func allSelected() -> Bool {
        return !agreeStatus[0] || !agreeStatus[1]
    }
}

#Preview {
    AgreementTermsSheet(callSignUp: .constant(false))
}
