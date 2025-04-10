//
//  PostCard.swift
//  RunUs
//
//  Created by 가은 on 11/1/24.
//

import SwiftUI

struct PostCard: View {
    var runningRecord: RunningRecord
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 러닝 정보
            runningInfo()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.primaryFill)
                .stroke(.secondaryFill, lineWidth: 1)
        )
    }
    
    @ViewBuilder
    func runningInfo() -> some View {
        HStack {
            // 러닝 정보
            VStack(alignment: .leading, spacing: 12) {
                Text(DateManager.shared.getDateString(date: runningRecord.start_date_time, type: .weekly))
                    .font(.body2_semibold)
                    .foregroundStyle(.quaternaryGray)
                Text(runningRecord.title)
                    .font(.title5_bold)
                HStack(spacing: 20) {
                    detailInfo(title: "거리", contents: String(format: "%.2f", Double(runningRecord.distance_in_meters)/Double(1000)))
                    detailInfo(title: "페이스", contents: "\(runningRecord.average_pace_in_miliseconds)")
                    detailInfo(title: "시간", contents: "\(runningRecord.duration_in_seconds)")
                }
            }
            .foregroundStyle(.primaryGray)
            
            Spacer()
            
            // 경로 이미지
        }
    }
    
    @ViewBuilder
    func detailInfo(title: String, contents: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption_regular)
                .foregroundStyle(.quaternaryGray)
            Text(contents)
                .font(.caption_bold)
                .foregroundStyle(.primaryGray)
        }
    }
}

