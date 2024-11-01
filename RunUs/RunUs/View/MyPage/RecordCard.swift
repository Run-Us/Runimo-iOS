//
//  RecordCard.swift
//  RunUs
//
//  Created by 가은 on 10/30/24.
//

import SwiftUI

struct RecordCard: View {
    @ObservedObject var myPageVM: MyPageViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                // 기간
                Text(myPageVM.periodText)
                    .font(.body2_semibold)
                    .foregroundStyle(.gray900)
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "chevron.down")
                        .resizable()
                        .frame(width: 14, height: 8)
                        .foregroundStyle(.gray500)
                }
            }
            
            HStack(spacing: 53) {
                infoText(title: "러닝", contents: "2")
                infoText(title: "거리", contents: "7.71km")
                infoText(title: "시간", contents: "51m 36s")
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.tone)
                .stroke(.gray200, lineWidth: 1)
        )
    }
    
    @ViewBuilder
    func infoText(title: String, contents: String) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(title)
                .font(.caption_regular)
                .foregroundStyle(.gray500)
            Text(contents)
                .font(.title5_bold)
                .foregroundStyle(.gray900)
        }
    }
}

#Preview {
    RecordCard(myPageVM: .init())
}
