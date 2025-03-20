//
//  MapPage.swift
//  RunUs
//
//  Created by 가은 on 9/9/24.
//

import NMapsMap
import SwiftUI

struct MapPage: View {
    @EnvironmentObject var mapVM: MapViewModel
    
    var body: some View {
        Map()
    }
}

struct Map: UIViewRepresentable {
    @EnvironmentObject var mapVM: MapViewModel
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let map = NMFNaverMapView()
        map.showLocationButton = true
        map.mapView.positionMode = .direction
        map.showZoomControls = false
        map.showScaleBar = false
        
        return map
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let map = uiView.mapView
        
        // 사용자 위치로 지도 화면 이동
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(from: mapVM.userLocation.coordinate))
        map.moveCamera(cameraUpdate)
        
        // userPath에 값이 있을 때만 경로 그리기
        if !mapVM.userPath.isEmpty {
            addPathOverlay(map)
        }
    }
    
    // 경로선 그리는 함수
    func addPathOverlay(_ map: NMFMapView) {
        let pathOverlay = NMFPath()
        pathOverlay.color = .highlight
        pathOverlay.outlineColor = .primary400
        pathOverlay.outlineWidth = 1
        pathOverlay.path = NMGLineString(points: mapVM.userPath)
        pathOverlay.mapView = map
    }
}

#Preview {
    MapPage()
}
