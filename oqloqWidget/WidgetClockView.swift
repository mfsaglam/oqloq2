//
//  WidgetClockView.swift
//  oqloqWidget
//

import SwiftUI

/// The widget's own clock.
///
/// Separate from the app's `OqloqView` on purpose. A widget is a small,
/// static canvas: it renders once per timeline entry, so there is no ticking
/// indicator to animate, and shadows that look right at phone size are too
/// heavy at this scale. Keeping it apart means the widget can be tuned for
/// that without compromising the app, and vice versa.
///
/// What it does *not* duplicate is the proportions. Those come from
/// `ClockGeometry`, as does the app's clock, because when each carried its
/// own numbers the arcs ended up on a different circle from the ring.
struct WidgetClockView: View {
    let routines: [PresentableRoutine]
    /// Fixed for this entry; a widget view is rendered once and never ticks.
    let angle: Angle
    var light: LightSource = .default

    /// Shadows are scaled back: at widget size the app's values crowd the
    /// edges of the container.
    private let shadowScale: CGFloat = 0.6

    var body: some View {
        GeometryReader { proxy in
            let diameter = min(proxy.size.width, proxy.size.height)
            ZStack {
                clockBody(diameter: diameter)
                indicator(diameter: diameter)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }

    private func clockBody(diameter: CGFloat) -> some View {
        let cast = light.shadowOffset(
            diameter: diameter,
            spread: ClockMaterial.castShadowSpread * shadowScale
        )
        let ambient = light.shadowOffset(
            diameter: diameter,
            spread: ClockMaterial.ambientShadowSpread * shadowScale
        )
        return ZStack {
            Circle()
                .stroke(ClockMaterial.ringTrack, lineWidth: diameter * ClockGeometry.ringStroke)
                .frame(width: diameter * ClockGeometry.ring, height: diameter * ClockGeometry.ring)

            ForEach(routines) { routine in
                RoutineView(
                    routine: routine,
                    diameter: diameter * ClockGeometry.ring,
                    lineWidth: diameter * ClockGeometry.ringStroke
                )
            }

            ClockFace(diameter: diameter * ClockGeometry.face, light: light)
        }
        .compositingGroup()
        .shadow(
            color: ClockMaterial.ambientShadow,
            radius: diameter * ClockMaterial.ambientShadowRadius * shadowScale,
            x: ambient.width,
            y: ambient.height
        )
        .shadow(
            color: ClockMaterial.castShadow,
            radius: diameter * ClockMaterial.castShadowRadius * shadowScale,
            x: cast.width,
            y: cast.height
        )
    }

    /// No animation: there is nothing to animate between widget renders.
    private func indicator(diameter: CGFloat) -> some View {
        Circle()
            .trim(from: 0.0, to: ClockGeometry.indicatorWidth)
            .stroke(ClockMaterial.indicator, lineWidth: diameter * ClockGeometry.indicatorLength)
            .frame(
                width: diameter * ClockGeometry.indicatorRing,
                height: diameter * ClockGeometry.indicatorRing
            )
            .rotationEffect(.degrees(ClockGeometry.originRotation))
            .rotationEffect(angle)
    }
}
