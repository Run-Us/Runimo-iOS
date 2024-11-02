//
//  MapViewModel.swift
//  RunUs
//
//  Created by 가은 on 9/11/24.
//

import CoreLocation
import Foundation
import NMapsMap
import SwiftUI

class MapViewModel: NSObject, ObservableObject {
    private let locationManager: CLLocationManager
    @ObservedObject var motionManager: MotionManager
    @Published var userLocation: CLLocation = CLLocation(latitude: 37.564214, longitude: 127.001699)
    @Published var userPath: [NMGLatLng] = []
    @Published var isRunning: Bool = false
    
    // Run Path
    @Published var coordinatesRange: (minLat: Double, maxLat: Double, minLng: Double, maxLng: Double) = (0,0,0,0)
    
    override init() {
        locationManager = CLLocationManager()
        motionManager = MotionManager()
        super.init()
        locationManager.delegate = self
        checkLocationPermission()
    }
    
    func checkLocationPermission() {
        switch locationManager.authorizationStatus {
        case .denied:
            print("위치 권한 거부 상태")
        case .notDetermined, .restricted:
            locationManager.requestAlwaysAuthorization()
        default:
            break
        }
        
        // 정확한 위치 설정이 꺼져있는 경우 요청
        switch locationManager.accuracyAuthorization {
        case .reducedAccuracy:
            locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "러닝 기록을 위해 정확한 위치 설정을 켜주세요.")
        default:
            break
        }
    }
}

extension MapViewModel: CLLocationManagerDelegate {
    // 사용자 위치 업데이트
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        userLocation = newLocation
        userPath.append(NMGLatLng(from: newLocation.coordinate))
        calculateCoordinateRange(location: newLocation.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("error: ", error.localizedDescription)
    }
    
    // 사용자 위치 추적 시작
    func startUpdatingLocation() {
        isRunning = true
        locationManager.startUpdatingLocation()
        motionManager.startUpdatesMotion()
    }
    
    // 사용자 위치 추적 멈춤
    func stopUpdatingLocation() {
        isRunning = false
        locationManager.stopUpdatingLocation()
        motionManager.stopRunningMotionData()
    }
    
}

// MARK: Path
extension MapViewModel {
    
    // 경로 그릴 좌표 범위 구하기
    func calculateCoordinateRange(location: CLLocationCoordinate2D)  {
        // first update
        if coordinatesRange.minLat == 0.0 && coordinatesRange.maxLat == 0.0 {
            coordinatesRange = (location.latitude, location.latitude, location.longitude, location.longitude)
        }
        
        coordinatesRange.maxLat = max(coordinatesRange.maxLat, location.latitude + 0.00002)
        coordinatesRange.minLat = min(coordinatesRange.minLat, location.latitude - 0.00002)
        coordinatesRange.maxLng = max(coordinatesRange.maxLng, location.longitude + 0.00002)
        coordinatesRange.minLng = min(coordinatesRange.minLng, location.longitude - 0.00002)
    }
    
    // 좌표 스크린 사이즈로 정규화
    func coordinateToCGPoint(point: NMGLatLng, size: CGSize) -> CGPoint {
        let normalizedX = (point.lng - coordinatesRange.minLng) / (coordinatesRange.maxLng - coordinatesRange.minLng)
        let normalizedY = 1 - (point.lat - coordinatesRange.minLat) / (coordinatesRange.maxLat - coordinatesRange.minLat)
        
        let lng = normalizedX * size.width
        let lat = normalizedY * size.height
        
        return CGPoint(x: lng, y: lat)
    }
}
