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
                barGraph()
                    .frame(width: geometry.size.width-48)
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
                .padding(.bottom, 18)
        }
    }
    
    @ViewBuilder
    func xLine(km: Double) -> some View {
        HStack(spacing: 12) {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray300)
                
            Text("\(String(format: "%.1f", km)) km")
                .font(.caption_regular)
                .foregroundStyle(.gray500)
        }
    }
    
    @ViewBuilder
    func barGraph() -> some View {
        HStack {
            ForEach(myPageVM.xData, id: \.self) { item in
                Spacer()
                Text(item)
                    .font(.caption_regular)
                    .foregroundStyle(.gray500)
                Spacer()
            }
        }
    }
}

#Preview {
    MyGraph(myPageVM: .init())
}
