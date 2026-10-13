//
//  OqloqView.swift
//  oqloq
//
//  Created by Saglam, Fatih on 16.07.2024.
//

import SwiftUI

/// The app's clock: a thin ring of coloured routine arcs around a matte disc,
/// with a short indicator at the disc's edge.
///
/// Every dimension is a proportion of the clock's own measured diameter, so
/// the same view is correct on any screen. The widget draws its own version
/// of this, tuned for a small canvas; both take their proportions from
/// `ClockGeometry` so they cannot drift apart.
struct OqloqView: View {

    @StateObject var vm = OqloqViewModel(engine: ClockEngine())

    let routines: [PresentableRoutine]

    /// Where the light comes from. Drives the shadow's direction and length
    /// and the face's highlight together, so they always agree.
    var light: LightSource = .default

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

    /// Track, arcs and face shadowed together, so the clock casts one
    /// silhouette on the wall rather than each layer casting its own.
    private func clockBody(diameter: CGFloat) -> some View {
        let cast = light.shadowOffset(diameter: diameter, spread: ClockMaterial.castShadowSpread)
        let ambient = light.shadowOffset(diameter: diameter, spread: ClockMaterial.ambientShadowSpread)
        return ZStack {
            routineTrack(diameter: diameter)
            allRoutines(diameter: diameter)
            face(diameter: diameter)
        }
        .compositingGroup()
        .shadow(
            color: ClockMaterial.ambientShadow,
            radius: diameter * ClockMaterial.ambientShadowRadius,
            x: ambient.width,
            y: ambient.height
        )
        .shadow(
            color: ClockMaterial.castShadow,
            radius: diameter * ClockMaterial.castShadowRadius,
            x: cast.width,
            y: cast.height
        )
    }

    /// The unpainted remainder of the routine ring.
    private func routineTrack(diameter: CGFloat) -> some View {
        Circle()
            .stroke(ClockMaterial.ringTrack, lineWidth: diameter * ClockGeometry.ringStroke)
            .frame(width: diameter * ClockGeometry.ring, height: diameter * ClockGeometry.ring)
    }

    private func allRoutines(diameter: CGFloat) -> some View {
        ForEach(routines) { routine in
            RoutineView(
                routine: routine,
                diameter: diameter * ClockGeometry.ring,
                lineWidth: diameter * ClockGeometry.ringStroke
            )
        }
    }

    private func face(diameter: CGFloat) -> some View {
        ClockFace(diameter: diameter * ClockGeometry.face, light: light)
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
            .rotationEffect(vm.angle)
            .animation(.easeInOut(duration: 0.5), value: vm.angle)
    }
}

#Preview {
    ZStack {
        WallTheme.sand.color
        OqloqView(
            vm: OqloqViewModel(engine: StaticClockEngine(hour: 10, minute: 10)),
            routines: [.init(start: 0.9, end: 0.3, color: .red)]
        )
    }
}
