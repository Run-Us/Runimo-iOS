//
//  Tutorial2Sheet.swift
//  Runimo
//
//  Created by 가은 on 7/2/25.
//

import SwiftUI

struct Tutorial2Sheet: View {
    @EnvironmentObject var sharedData: SharedData
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("도감을 완성해보세요!")
                        .font(.title5_bold)
                        .foregroundStyle(.primaryGray)
                        .padding(.vertical, 16)
                    Spacer()
                }
                Text("각기 다른 스테이지에서 개성 넘치는 캐릭터들을 만날 수 있어요. 꾸준히 달려 모든 캐릭터를 모아보세요!")
                    .font(.body2_medium)
                    .foregroundStyle(.tertiaryGray)
            }
            .padding(.horizontal, 20)
            
            Image("tutorial2")
            
            VStack(spacing: 12) {
                Divider()
                HStack(spacing: 12) {
                    cancelButton()
                    okButton()
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    @ViewBuilder
    private func cancelButton() -> some View {
        Button {
            sharedData.showTutorial2Sheet = false
            sharedData.showTutorial1Sheet = true
        } label: {
            Text("이전")
                .font(.body1_bold)
                .foregroundStyle(.primaryGray)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(.primaryBG)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.secondaryFill, lineWidth: 1)
                )
        }
    }
    
    @ViewBuilder
    private func okButton() -> some View {
        Button {
            sharedData.showTutorial1Sheet = false
            sharedData.showTutorial2Sheet = false
        } label: {
            Text("확인했어요")
                .font(.body1_bold)
                .foregroundStyle(.white)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(.primary400)
                .cornerRadius(8)
        }
    }
}

#Preview {
    Tutorial2Sheet()
}
