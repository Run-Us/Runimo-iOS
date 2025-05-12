//
//  DateSheet.swift
//  RunUs
//
//  Created by 가은 on 11/6/24.
//

import SwiftUI

struct DateSheet: View {
    var recordType: RecordType = .monthly
    @EnvironmentObject var sharedData: SharedData
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.primaryBG.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 18) {
                Text("기간 설정")
                    .font(.title5_bold)
                
                ScrollView {
                    let dateList = DateManager.shared.getDateList(type: recordType)
                    ForEach(Array(zip(dateList.indices, dateList)), id: \.0) { index, item in
                        Button {
                            if sharedData.currentMainTab == .my {
                                DateManager.shared.updateDate(index: index, type: recordType)
                            } else if sharedData.currentMainTab == .session {
                                sharedData.selectedDateForSessionTab = DateManager.shared.moveMonth(index: index)
                            }
                            dismiss()
                        } label: {
                            HStack {
                                Text(item)
                                    .font(.body2_medium)
                                    .foregroundStyle(.secondaryGray)
                                    .padding(.vertical, 10)
                                Spacer()
                            }
                        }
                    }
                }
            }
            .foregroundStyle(.primaryGray)
            .padding(20)
        }
    }
}

#Preview {
    DateSheet()
}
