//
//  PollingManager.swift
//  RunUs
//
//  Created by byeoungjik on 11/2/24.
//

import Foundation

class PollingManager: ObservableObject {
    static let shared = PollingManager(pollingInterval: 2.0)
    
    let pollingInterval: TimeInterval
    private var pollingTimer: Timer?
    private var pollingAction: (() -> Void)?

    private init(pollingInterval: TimeInterval) {
        self.pollingInterval = pollingInterval
    }

    func startPolling(pollingAction: @escaping () -> Void) {
        self.pollingAction = pollingAction
        self.pollingTimer = Timer.scheduledTimer(
            withTimeInterval: pollingInterval,
            repeats: true
        ) { [weak self] _ in
            self?.pollingAction?()
        }
    }

    func stopPolling() {
        pollingTimer?.invalidate()
        pollingTimer = nil
        pollingAction = nil
        print("stop polling")
    }
}
