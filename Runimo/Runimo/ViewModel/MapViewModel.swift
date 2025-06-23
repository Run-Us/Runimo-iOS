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
    private var authorizationCompletion: ((Bool) -> Void)?
    
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
            locationManager.requestWhenInUseAuthorization()
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
    
    // 위치 항상 허용 확인
    func checkLocationAlwaysAuthorization(completion: @escaping (Bool) -> Void) {
        self.authorizationCompletion = completion
        
        if locationManager.authorizationStatus == .authorizedAlways {
            completion(true)
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
}

extension MapViewModel: CLLocationManagerDelegate {
    // 권한이 변경될 때 호출
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationCompletion?(status == .authorizedAlways)
        authorizationCompletion = nil
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
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("error: ", error.localizedDescription)
    }
    
    // 모션 데이터 권한 요청 
    func requestMotionAuthorization() {
        motionManager.startUpdatesMotion()
        motionManager.stopRunningMotionData()
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
