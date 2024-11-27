//
//  MyGraph.swift
//  RunUs
//
//  Created by 가은 on 10/31/24.
//

import SwiftUI

struct MyGraph: View {
    @ObservedObject var myPageVM: MyPageViewModel
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                // 배경 라인 및 범위
                background()
                // 그래프
                totalGraph(geometry.size.height - 36)
                    .frame(width: geometry.size.width - 48, height: geometry.size.height)
                    .padding(.top, 12)
            }
        }
    }
    
    @ViewBuilder
    func background() -> some View {
        VStack {
            xLine(km: myPageVM.graphDisplay.maxYLength)
            Spacer()
            xLine(km: myPageVM.graphDisplay.maxYLength/2)
            Spacer()
            xLine(km: 0)
                .padding(.bottom, 24)
        }
    }
    
    // 가로선
    @ViewBuilder
    func xLine(km: Double) -> some View {
        HStack(alignment: .bottom, spacing: 12) {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray300)
                
            Text("\(String(format: "%.1f", km)) km")
                .font(.caption_regular)
                .foregroundStyle(.gray500)
        }
        .frame(height: 12)
    }
    
    @ViewBuilder
    func totalGraph(_ height: Double) -> some View {
        switch myPageVM.recordType {
        case .monthly: monthlyGraph(height)
        case .weekly, .yearly: weekYearGraph(height)
        }
    }
    
    // 주간, 연간 그래프
    @ViewBuilder
    func weekYearGraph(_ height: Double) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(myPageVM.xData.indices, id: \.self) { idx in
                    weekYearBarGraph(xdata: myPageVM.xData[idx], ydata: myPageVM.graphDisplay.distanceList[idx], height: height)
                }
            }
        }
    }
    
    // 주간, 연간 막대 바 하나
    @ViewBuilder
    func weekYearBarGraph(xdata: String, ydata: Double, height: Double) -> some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: myPageVM.barGraphCornerRadius)
                .fill(.highlight)
                .frame(height: (ydata/myPageVM.graphDisplay.maxYLength) * height)
                .padding(.horizontal, myPageVM.graphSpacing/2)
            Text(xdata)
                .font(.caption_regular)
                .foregroundStyle(.gray500)
                .lineLimit(1)
                .frame(width: 15, height: 24)
        }
    }
    
    // 월간 그래프
    @ViewBuilder
    func monthlyGraph(_ height: Double) -> some View {
        VStack(spacing: 0) {
            // 막대 그래프
            HStack(spacing: 0) {
                ForEach(myPageVM.graphDisplay.distanceList, id: \.self) { item in
                    RoundedRectangle(cornerRadius: myPageVM.barGraphCornerRadius)
                        .fill(.highlight)
                        .frame(height: (item/myPageVM.graphDisplay.maxYLength) * height)
                        .padding(.horizontal, myPageVM.graphSpacing/2)
                }
            }
            // 날짜 text
            HStack(spacing: 0) {
                ForEach(myPageVM.xData, id: \.self) { item in
                    if myPageVM.checkMonthlyData(data: item) {
                        Text(item)
                            .font(.caption_regular)
                            .foregroundStyle(.gray500)
                            .lineLimit(1)
                            .frame(width: 15, height: 24, alignment: .center)
                    } else {
                        Spacer()
                            .frame(height: 24)
                    }
                }
            }
        }
    }
}

#Preview {
    MyGraph(myPageVM: .init())
}
