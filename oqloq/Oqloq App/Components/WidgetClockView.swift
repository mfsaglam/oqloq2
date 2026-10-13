//
//  WidgetClockView.swift
//  oqloq
//

import SwiftUI

/// The widget's clock.
///
/// A thin wrapper around `ClockDial`, the same drawing the app uses, so the
/// widget and the home screen are the same object at different sizes. What
/// differs is only what a widget can do: the indicator is fixed for the
/// entry and nothing animates, because a widget view is rendered once per
/// timeline entry.
struct WidgetClockView: View {
    let routines: [PresentableRoutine]
    /// Fixed for this entry; a widget view never ticks.
    let angle: Angle
    var light: LightSource = .default

    var body: some View {
        ClockDial(routines: routines, angle: angle, light: light)
    }
}
