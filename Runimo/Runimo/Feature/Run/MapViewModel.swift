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
        locationManager.allowsBackgroundLocationUpdates = true
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
        
        let now = Date()
        if let lastTime = lastUpdateTime, now.timeIntervalSince(lastTime) < 1 {
            return
        }
        
        lastUpdateTime = now
        userLocation = newLocation
        userPath.append(NMGLatLng(from: newLocation.coordinate))
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
    
    func stopRunning(runningType: RunningType) {
        stopUpdatingLocation()
        motionManager.savePaceWhenStopRunning()
        userPath.removeAll()
        motionManager.initMotionManager()
        motionManager.runningResult.end_at = Date()
    }
}
