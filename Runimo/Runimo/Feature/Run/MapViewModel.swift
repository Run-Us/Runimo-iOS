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
    private var lastUpdateTime: Date?
    
    override init() {
        locationManager = CLLocationManager()
        motionManager = MotionManager()
        super.init()
        locationManager.delegate = self

        // 백그라운드 위치 추적 설정
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true  // 백그라운드 위치 인디케이터 노출
        locationManager.pausesLocationUpdatesAutomatically = false  // 위치 업데이트 자동 종료 거부
        locationManager.activityType = .fitness  // 러닝/워킹 최적화
        locationManager.desiredAccuracy = kCLLocationAccuracyBest  // 최고 정확도

        print("📍 LocationManager 초기화 완료")
    }
    
    /// 위치 권한 요청 시작 (RunTab에서 호출)
    func checkLocationPermission() {
        let status = locationManager.authorizationStatus
        print("📍 현재 위치 권한 상태: \(status.rawValue)")

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()

        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()

        default:
            break
        }
    }
}

extension MapViewModel: CLLocationManagerDelegate {
    // 위치 권한 상태 변경 감지 (자동으로 2단계 요청 처리)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        print("📍 위치 권한 상태 변경: \(status.rawValue)")

        switch status {
        case .authorizedWhenInUse:
            manager.requestAlwaysAuthorization()

        case .authorizedAlways:
            if !UserDefaults.standard.bool(forKey: "hasRequestedMotionPermission") {
                // 모션 권한 요청
                motionManager.startUpdatesMotion()
                motionManager.stopRunningMotionData()
                UserDefaults.standard.set(true, forKey: "hasRequestedMotionPermission")
            }

        default:
            break
        }
    }

    // 사용자 위치 업데이트
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }

        let now = Date()
        if let lastTime = lastUpdateTime, now.timeIntervalSince(lastTime) < 1 {
            return
        }

        lastUpdateTime = now
        userLocation = newLocation
        userPath.append(NMGLatLng(from: newLocation.coordinate))
        print("📍 위치 업데이트: \(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("❌ 위치 업데이트 에러: \(error.localizedDescription)")
    }

    // 사용자 위치 추적 시작
    func startUpdatingLocation() {
        isRunning = true
        print("🏃 위치 추적 시작 - 권한 상태: \(locationManager.authorizationStatus.rawValue)")
        print("🏃 백그라운드 업데이트 설정: \(locationManager.allowsBackgroundLocationUpdates)")
        locationManager.startUpdatingLocation()
        motionManager.startUpdatesMotion()
    }
    
    // 사용자 위치 추적 멈춤
    func stopUpdatingLocation() {
        isRunning = false
        locationManager.stopUpdatingLocation()
        motionManager.stopRunningMotionData()
    }
    
    func stopRunning(runningType: RunningType) {
        stopUpdatingLocation()
        motionManager.savePaceWhenStopRunning()
        userPath.removeAll()
        motionManager.initMotionManager()
        motionManager.runningResult.end_at = Date()
    }
}
