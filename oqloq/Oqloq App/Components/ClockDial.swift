//
//  ClockDial.swift
//  oqloq
//

import SwiftUI

/// The clock itself, drawn once and used by both the app and the widget.
///
/// The scene is layered by height: the wall is the ground, the disc stands
/// off it, and the routine ring stands off further still. Each layer casts
/// its own shadow scaled by its height, rather than the whole clock casting
/// one flat silhouette, which is what lets the ring's shadow fall across the
/// disc's rim and sell the gap between them.
///
/// Drawing order follows that relief: disc first, then the indicator on its
/// face, then the ring on top, so the ring's shadow lands over the disc.
struct ClockDial: View {
    let routines: [PresentableRoutine]
    /// Where the indicator points. Supplied by the caller, so the app can
    /// animate it and the widget can hold it still.
    let angle: Angle
    var light: LightSource = .default

    var body: some View {
        GeometryReader { proxy in
            let diameter = min(proxy.size.width, proxy.size.height)
            ZStack {
                face(diameter: diameter)
                indicator(diameter: diameter)
                ring(diameter: diameter)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }

    private func face(diameter: CGFloat) -> some View {
        raised(
            ClockFace(diameter: diameter * ClockGeometry.face, light: light),
            diameter: diameter,
            height: ClockMaterial.faceHeight
        )
    }

    /// Track and arcs together: one piece of tube, part of it painted.
    private func ring(diameter: CGFloat) -> some View {
        let ringDiameter = diameter * ClockGeometry.ring
        let width = diameter * ClockGeometry.ringStroke
        return raised(
            ZStack {
                TubeArc(
                    start: 0, end: 1,
                    diameter: ringDiameter, lineWidth: width,
                    color: ClockMaterial.ringTrack, light: light
                )
                ForEach(routines) { routine in
                    RoutineView(
                        routine: routine,
                        diameter: ringDiameter,
                        lineWidth: width,
                        light: light
                    )
                }
            },
            diameter: diameter,
            height: ClockMaterial.ringHeight
        )
    }

    /// A short radial tick near the face's edge, pointing inward. Not a hand:
    /// it has no centre pivot and never reaches the middle.
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

    /// Lifts a layer off whatever is behind it by the shadow it throws.
    private func raised(_ layer: some View, diameter: CGFloat, height: CGFloat) -> some View {
        let cast = light.shadowOffset(
            diameter: diameter,
            spread: ClockMaterial.castShadowSpread * height
        )
        let ambient = light.shadowOffset(
            diameter: diameter,
            spread: ClockMaterial.ambientShadowSpread * height
        )
        return layer
            .compositingGroup()
            .shadow(
                color: ClockMaterial.ambientShadow,
                radius: diameter * ClockMaterial.ambientShadowRadius * height,
                x: ambient.width,
                y: ambient.height
            )
            .shadow(
                color: ClockMaterial.castShadow,
                radius: diameter * ClockMaterial.castShadowRadius * height,
                x: cast.width,
                y: cast.height
            )
    }
}
