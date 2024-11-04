//
//  RunPath.swift
//  RunUs
//
//  Created by 가은 on 11/2/24.
//

import SwiftUI

struct RunPath: View {
    @EnvironmentObject var mapVM: MapViewModel
    
    var body: some View {
        VStack {
            Canvas { context, size in
                var path = Path()
                
                guard !mapVM.userPath.isEmpty else { return }
                
                // 시작점
                if let firstPoint = mapVM.userPath.first {
                    let startPoint = mapVM.coordinateToCGPoint(point: firstPoint, size: size)
                    path.move(to: startPoint)
                    
                    let circle = Path(ellipseIn: CGRect(x: startPoint.x-11, y: startPoint.y-11, width: 22, height: 22))
                    context.fill(circle, with: .color(.primary500))
                }
                
                // 이어 그리기
                for point in mapVM.userPath {
                    let point = mapVM.coordinateToCGPoint(point: point, size: size)
                    path.addLine(to: point)
                }
                
                context.stroke(path, with: .color(.primary500), lineWidth: 8)
                
                // 끝점
                if let lastPoint = mapVM.userPath.last {
                    let endPoint = mapVM.coordinateToCGPoint(point: lastPoint, size: size)
                    path.move(to: endPoint)
                    
                    let circle = Path(ellipseIn: CGRect(x: endPoint.x-11, y: endPoint.y-11, width: 22, height: 22))
                    context.fill(circle, with: .color(.primary500))
                }
            }
            .background(.clear)
        }
        .onAppear {
            mapVM.mapImageURL = mapVM.savePathAsImage()
        }
    }
}

#Preview {
    RunPath()
}
