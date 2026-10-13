//
//  StaticClockEngine.swift
//  oqloq
//

import SwiftUI

/// A clock engine frozen at one time of day.
///
/// Used by the widget, where a repeating timer could never fire because the
/// view is rendered once per timeline entry, and by previews and snapshots,
/// where a fixed angle is what makes successive renders comparable.
struct StaticClockEngine: ClockEngineInterface {
    private let angle: Angle

    init(hour: Int, minute: Int) {
        self.angle = (hour * 60 + minute).angle()
    }

    init(date: Date, calendar: Calendar = .current) {
        self.init(
            hour: calendar.component(.hour, from: date),
            minute: calendar.component(.minute, from: date)
        )
    }

    func currentAngle() -> Angle { angle }

    /// Nothing to schedule; the angle never changes.
    func updateAnglePeriodically(completion: @escaping () -> Void) {}
}
