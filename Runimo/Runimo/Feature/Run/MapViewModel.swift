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
    
    func checkLocationPermission() {
        let status = locationManager.authorizationStatus
        print("📍 현재 위치 권한 상태: \(status.rawValue)")

        switch status {
        case .denied:
            print("❌ 위치 권한 거부 상태 - 설정에서 '항상 허용'으로 변경 필요")
        case .notDetermined, .restricted:
            print("⚠️ 위치 권한 미설정 - Always 권한 요청 중...")
            locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            print("⚠️ '앱 사용 중에만 허용' 상태 - '항상 허용'으로 변경 필요")
        case .authorizedAlways:
            print("✅ '항상 허용' 상태 - 백그라운드 추적 가능")
        @unknown default:
            break
        }

        // 정확한 위치 설정이 꺼져있는 경우 요청
        switch locationManager.accuracyAuthorization {
        case .reducedAccuracy:
            print("⚠️ 정확한 위치 설정 OFF")
            locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "러닝 기록을 위해 정확한 위치 설정을 켜주세요.")
        case .fullAccuracy:
            print("✅ 정확한 위치 설정 ON")
        @unknown default:
            break
        }
    }
}

extension MapViewModel: CLLocationManagerDelegate {
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
