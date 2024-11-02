//
//  RunPath.swift
//  RunUs
//
//  Created by 가은 on 11/2/24.
//

import SwiftUI

struct RunPath: View {
    @ObservedObject var mapVM: MapViewModel
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                var path = Path()
                
                guard !mapVM.userPath.isEmpty else { return }
                
                // 시작점
                if let firstPoint = mapVM.userPath.first {
                    let startPoint = mapVM.coordinateToCGPoint(point: firstPoint, size: geometry.size)
                    path.move(to: startPoint)
                }
                
                // 이어 그리기
                for point in mapVM.userPath {
                    let point = mapVM.coordinateToCGPoint(point: point, size: geometry.size)
                    path.addLine(to: point)
                }
                
                context.stroke(path, with: .color(.primary500), lineWidth: 8)
            }
            .frame(height: geometry.size.width)
        }
    }
}

#Preview {
    RunPath(mapVM: .init())
}
