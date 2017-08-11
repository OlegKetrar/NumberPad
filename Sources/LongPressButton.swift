//
//  LongPressButton.swift
//  NumberPad
//
//  Created by Oleg Ketrar on 30.11.16.
//
//

import UIKit

final class LongPressButton: UIButton {

    private var timer: Timer?
    private var fireClosure: () -> Void = {}

    private let holdDelay: TimeInterval     = 0.45
    private var timerInterval: TimeInterval = 0.1
    private var startTimestamp: TimeInterval?

    deinit {
        timer?.invalidate()
        removeTarget(self, action: #selector(actionHold), for: .touchUpInside)
        removeTarget(self, action: #selector(actionRelease), for: .touchUpInside)
        removeTarget(self, action: #selector(actionRelease), for: .touchUpOutside)
    }

    private func invalidateTimer() {
        timer?.invalidate()
        startTimestamp = nil
    }

    /// start hold event recognition after delay
    private func recognizeHoldEvent() -> Bool {
        guard let startTimestamp = startTimestamp else { return false }
        let timestamp = Date().timeIntervalSinceReferenceDate
        return timestamp >= startTimestamp + holdDelay
    }

    // MARK: Subscribe

    func addAction(forContiniusHoldWith interval: TimeInterval, action: @escaping () -> Void) {

        // remove old timer
        invalidateTimer()

        // save
        timerInterval = interval
        fireClosure   = action

        // subscribe
        addTarget(self, action: #selector(actionHold), for: .touchDown)
        addTarget(self, action: #selector(actionRelease), for: .touchUpInside)
        addTarget(self, action: #selector(actionRelease), for: .touchUpOutside)
    }

    // MARK: Actions

    /// fire on touchDown & set timer to catch hold events
    @objc private func actionHold() {
        fireClosure()
        startTimestamp = Date().timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(timeInterval: timerInterval,
                                     target: self,
                                     selector: #selector(actionFire),
                                     userInfo: nil,
                                     repeats: true)
    }

    @objc private func actionRelease() {
        invalidateTimer()
    }

    @objc private func actionFire() {
        guard recognizeHoldEvent() else { return }
        fireClosure()
    }
}
