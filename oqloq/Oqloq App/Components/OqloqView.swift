//
//  OqloqView.swift
//  oqloq
//
//  Created by Saglam, Fatih on 16.07.2024.
//

import SwiftUI

/// The app's clock.
///
/// A thin wrapper around `ClockDial`: it owns the ticking view model and
/// animates the indicator between minutes. The drawing itself is `ClockDial`,
/// which the widget uses too, so the two cannot look different.
struct OqloqView: View {

    @StateObject var vm = OqloqViewModel(engine: ClockEngine())

    let routines: [PresentableRoutine]

    /// Where the light comes from. Drives the shadows' direction and length,
    /// the face's highlight and the ring's specular band together.
    var light: LightSource = .default

    var body: some View {
        ClockDial(routines: routines, angle: vm.angle, light: light)
            .animation(.easeInOut(duration: 0.5), value: vm.angle)
    }
}

#Preview {
    ZStack {
        WallTheme.sand.color
        OqloqView(
            vm: OqloqViewModel(engine: StaticClockEngine(hour: 10, minute: 10)),
            routines: WallThemeSample.sampleRoutines
        )
    }
}
