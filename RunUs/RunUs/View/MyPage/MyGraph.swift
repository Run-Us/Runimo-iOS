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
        HStack {
            ForEach(myPageVM.xData, id: \.self) { item in
                barGraph(item)
            }
        }
    }
    
    @ViewBuilder
    func barGraph(_ data: String) -> some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 8)
                .fill(.highlight)
            Text(data)
                .font(.caption_regular)
                .foregroundStyle(.gray500)
                .frame(height: 24)
        }
    }
}

#Preview {
    MyGraph(myPageVM: .init())
}
