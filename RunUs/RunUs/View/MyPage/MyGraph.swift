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
                totalGraph()
                    .frame(width: geometry.size.width-48)
                    .padding(.top, 12)
            }
        }
    }
    
    @ViewBuilder
    func background() -> some View {
        VStack {
            xLine(km: 9)
            Spacer()
            xLine(km: 4.5)
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
    func totalGraph() -> some View {
        switch (myPageVM.recordType) {
        case .monthly: monthlyGraph()
        case .weekly, .yearly: weekYearGraph()
        }
    }
    
    // 주간, 연간 그래프
    @ViewBuilder
    func weekYearGraph() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(myPageVM.xData, id: \.self) { item in
                    weekYearBarGraph(data: item)
                }
            }
        }
    }
    
    // 주간, 연간 막대 바 하나
    @ViewBuilder
    func weekYearBarGraph(data: String) -> some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: myPageVM.barGraphCornerRadius)
                .fill(.highlight)
                .padding(.horizontal, myPageVM.graphSpacing/2)
            Text(data)
                .font(.caption_regular)
                .foregroundStyle(.gray500)
                .lineLimit(1)
                .frame(width: 15, height: 24)
        }
    }
    
    // 월간 그래프
    @ViewBuilder
    func monthlyGraph() -> some View {
        VStack(spacing: 0) {
            // 막대 그래프
            HStack(spacing: 0) {
                ForEach(myPageVM.xData, id: \.self) { item in
                    RoundedRectangle(cornerRadius: myPageVM.barGraphCornerRadius)
                        .fill(.highlight)
                        .padding(.horizontal, myPageVM.graphSpacing/2)
                }
            }
            // 날짜 text
            HStack(spacing: 0) {
                ForEach(myPageVM.xData, id: \.self) { item in
                    if !myPageVM.checkMonthlyXData(data: item).isEmpty {
                        Text(item)
                            .font(.caption_regular)
                            .foregroundStyle(.gray500)
                            .lineLimit(1)
                            .frame(width: 15, height: 24, alignment: .center)
                            .background(.blue)
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
