//
//  MotionManager.swift
//  RunUs
//
//  Created by 가은 on 9/21/24.
//

import CoreMotion
import Foundation

class MotionManager: ObservableObject {
    let pedometer = CMPedometer()
    var timer: Timer?
    @Published var runningInfo: RunningInfo = RunningInfo()
    @Published var runningResult: RunningResult = RunningResult()
    private var secondsElapsed = 0  // 경과한 시간 저장
    private var pace = 0
    private var lastSegmentSeconds = 0
    
    func initMotionManager() {
        secondsElapsed = 0
        lastSegmentSeconds = 0
    }
    
    func getRunningTimeInt() -> Int { return secondsElapsed }
    func getRunningPace() -> Int { return pace }
    
    // 실시간 러닝 정보 수집 시작 
    func startUpdatesMotion() {
        
        // Timer를 사용하여 1초마다 업데이트
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            
            // 시간 업데이트
            getRunningTime()
            
            guard let startDate = runningResult.started_at else { return }
            
            pedometer.startUpdates(from: startDate) { (pedometerData, error) in

                guard let pedometerData = pedometerData, error == nil else {
                    print("data is nil")
                    return
                }
                
                DispatchQueue.main.async {
                    self.getMotionData(data: pedometerData)
                }
            }
        })
    }
    
    // update motion data
    func getMotionData(data: CMPedometerData) {
        if  let averagePace = data.averageActivePace,
            let distance = data.distance
        {
            
            if distance.intValue > 0 && distance.intValue%1000 == 0 {
                savePace(distance: distance.intValue)
            }
            pace = Int(averagePace.doubleValue*1000)
            let minPerKm = pace / 60
            let secPerKm = pace % 60
            self.runningInfo.averagePace = "\(minPerKm)\' \(secPerKm)\'\'"
            self.runningInfo.distance = distance.doubleValue / 1000
            
            self.runningResult.average_pace_in_milli_seconds = pace
            self.runningResult.total_distance_in_meters = distance.intValue
        }
    }
    
    // 러닝 시간 받아오기
    func getRunningTime() {
        self.secondsElapsed += 1  // 1초 증가
        
        // 초를 분:초 형식으로 변환
        let minutes = self.secondsElapsed / 60
        let seconds = self.secondsElapsed % 60
        self.runningInfo.runningTime = String(format: "%02d:%02d", minutes, seconds)
    }
    
    // 측정 stop
    func stopRunningMotionData() {
        pedometer.stopUpdates()
        stopTimer()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // 러닝 데이터 측정 가능 여부 확인
    func checkPedometerAuthorization(completion: @escaping (_ : Bool) -> Void) {
        guard CMPedometer.isDistanceAvailable() && CMPedometer.isPaceAvailable() else {
            print("거리 또는 페이스 측정 불가능")
            completion(false)
            return
        }
        
        completion(true)
    }
    
    // 구간별 페이스 저장
    func savePace(distance: Int) {
        if runningResult.segment_paces == nil {
            runningResult.segment_paces = []
        }
        runningResult.segment_paces?.append(SegmentPaces(distance: distance, pace: secondsElapsed - lastSegmentSeconds))
        lastSegmentSeconds = secondsElapsed
    }
    
    func savePaceWhenStopRunning() {
        if let distance = runningResult.total_distance_in_meters, distance%1000 > 0 {
            savePace(distance: distance%1000)
        }
    }
}
