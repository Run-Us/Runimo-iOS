//
//  RunningPostPage.swift
//  RunUs
//
//  Created by 가은 on 10/22/24.
//

import SwiftUI

struct RunningPostPage: View {
    @EnvironmentObject var navigation: NavigationManager
    @EnvironmentObject var mapVM: MapViewModel
    @EnvironmentObject var runVM: RunningViewModel
    @Environment(\.dismiss) var dismiss
    let recordId: String
    
    var body: some View {
        ZStack {
            Color.primaryBG
                .ignoresSafeArea()
            GeometryReader { geometry in
                Divider()
                
                VStack(alignment: .leading, spacing: 24) {
                    // 유저 정보
                    HStack(spacing: 24) {
                        // 프로필 사진
                        if let profile = UserDefaults.standard.string(forKey: "profileURL"),
                           let url = URL(string: profile),
                           let uiImage = UIImage(contentsOfFile: url.path) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        } else {
                            Image("default_user_profile")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(UserDefaults.standard.string(forKey: "nickname") ?? "닉네임")
                                .font(.title5_medium)
                            Text(DateManager.shared.getPostDateString(dateString: runVM.runningDetail?.started_at ?? ""))
                                .font(.caption_regular)
                                .foregroundStyle(.quaternaryGray)
                        }
                    }
                    
                    // 완료한 러닝 정보
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text((runVM.runningDetail?.total_distance ?? 0).toDistanceString())
                                .font(.title3_bold)
                            Text("거리")
                                .font(.caption_regular)
                                .foregroundStyle(.quaternaryGray)
                        }
                        
                        HStack(spacing: 32) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(convertPaceToString(pace: runVM.runningDetail?.average_pace ?? 0))
                                    .font(.title5_bold)
                                Text("페이스")
                                    .font(.caption_regular)
                                    .foregroundStyle(.quaternaryGray)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(convertTimeToString(seconds: runVM.runningDetail?.total_running_time ?? 0))
                                    .font(.title5_bold)
                                Text("시간")
                                    .font(.caption_regular)
                                    .foregroundStyle(.quaternaryGray)
                            }
                        }
                    }
                    
                    
                    // contents
                    if let description = runVM.runningDetail?.description {
                        Text(description)
                            .font(.body2_medium)
                    }
                    
                    // 지도 이미지
                    
                    // 구간별 페이스
                    segmentPaceList()
                        .padding(.vertical, 24)
                }
                .foregroundStyle(.primaryGray)
                .padding(.horizontal, 16)
                .padding(.vertical, 25)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: 6) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 14, height: 14)
                    }
                    Text(runVM.runningDetail?.title ?? "")
                        .font(.body1_medium)
                }
                .foregroundStyle(.primaryGray)
            }
        }
        .onAppear {
            runVM.getRunningDetail(runningId: recordId)
        }
    }
    
    @ViewBuilder
    private func segmentPaceList() -> some View {
        VStack {
            HStack {
                Text("구간별 페이스")
                    .font(.title5_bold)
                    .foregroundStyle(.primaryGray)
                Spacer()
                Text("평균 페이스: \(convertPaceToString(pace: runVM.runningDetail?.average_pace ?? 0))")
            }
            .padding(.bottom, 20)
            
            // 가장 빠른 페이스
            let minPacePerKM = runVM.runningDetail?.segment_pace_list
                    .map { Double($0.pace) / Double($0.distance) }
                    .min() ?? 1.0
            
            ForEach(runVM.runningDetail?.segment_pace_list ?? [], id:\.distance) { item in
                // 막대 그래프를 그리기 위한 비율
                let pacePerKM = Double(item.pace) / Double(item.distance)
                let normalized = (minPacePerKM / pacePerKM) * 0.9
                
                VStack(spacing: 4) {
                    HStack {
                        if item.distance >= 1000 {
                            Text("\(item.distance/1000)k")
                        } else {
                            Text(formatDistance(item.distance))
                        }
                        Spacer()
                        Text("\(item.pace/60):\(item.pace%60)")
                    }
                    .font(.caption_regular)
                    .foregroundStyle(.quaternaryGray)
                    
                    ProgressBar(progress: normalized)
                }
            }
        }
    }
    
    private func formatDistance(_ distance: Int) -> String {
        let km = Double(distance) / 1000
        let text = String(format: "%.2f", km)
        
        if text.hasSuffix("0") {
            return String(format: "%.1fk", km)
        }
        return "\(text)k"
    }
    
    private func convertPaceToString(pace: Int) -> String {
        if pace == 0 {
            return "-’--”"
        }
        let minPerKm = pace / 60
        let secPerKm = pace % 60
        return "\(minPerKm)’ \(secPerKm)”"
    }
    
    private func convertTimeToString(seconds: Int) -> String {
        if seconds >= 60 * 60 {     // 1시간 이상
            return "\(seconds/3600)h \((seconds%3600)/60)m"
        } else if seconds >= 60 {
            return "\(seconds/60)m \(seconds%60)s"
        } else {
            return "\(seconds%60)s"
        }
    }
}

