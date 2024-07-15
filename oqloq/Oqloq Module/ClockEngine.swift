//
//  ClockEngine.swift
//  oqloq
//
//  Created by Saglam, Fatih on 16.07.2024.
//

import SwiftUI

class ClockEngine: ClockEngineInterface {
    var periodicUpdatePolicy: TimeInterval {
        60
    }

    func currentAngle() -> Angle {
        let calendar = Calendar.current
        let currentTime = Date.now
        let hour = calendar.component(.hour, from: currentTime)
        let minute = calendar.component(.minute, from: currentTime)
        let second = calendar.component(.second, from: currentTime)
        let totalMinutes = (hour * 60 + minute) + second / 60
        return totalMinutes.angle()
    }
    
    func updateAnglePeriodically(completion: @escaping () -> Void) {
        Timer.scheduledTimer(withTimeInterval: periodicUpdatePolicy, repeats: true) { _ in
            completion()
        }
    }
}
