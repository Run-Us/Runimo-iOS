//
//  PollingManager.swift
//  RunUs
//
//  Created by byeoungjik on 11/2/24.
//

import Foundation

class PollingManager: ObservableObject {
    let pollingInterval: TimeInterval
    private var pollingTimer: Timer?
    private var pollingAction: (() -> Void)?

    init(pollingInterval: TimeInterval) {
        self.pollingInterval = pollingInterval
    }

    func startPolling(pollingAction: @escaping () -> Void) {
        self.pollingAction = pollingAction
        self.pollingTimer = Timer.scheduledTimer(
            withTimeInterval: pollingInterval,
            repeats: true
        ) { _ in
            self.pollingAction?()
        }
    }

    func stopPolling() {
        pollingTimer?.invalidate()
        pollingTimer = nil
        pollingAction = nil
    }
}
