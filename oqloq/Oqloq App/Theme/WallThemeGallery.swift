//
//  WallThemeGallery.swift
//  oqloq
//
//  Preview scaffolding for comparing wall themes side by side.
//

import SwiftUI

/// A clock engine frozen at one time of day, so previews of different themes
/// are directly comparable instead of each rendering at "now".
struct FixedAngleClockEngine: ClockEngineInterface {
    let hour: Int
    let minute: Int

    func currentAngle() -> Angle {
        (hour * 60 + minute).angle()
    }

    /// Previews never advance; nothing to schedule.
    func updateAnglePeriodically(completion: @escaping () -> Void) {}
}

/// One wall, with the clock drawn on it at a fixed time.
struct WallThemeSample: View {
    let theme: WallTheme
    var routines: [PresentableRoutine] = WallThemeSample.sampleRoutines
    var hour: Int = 10
    var minute: Int = 10

    /// A plausible day, including a routine that spans midnight, so arcs are
    /// exercised the same way in every theme.
    static let sampleRoutines: [PresentableRoutine] = [
        .init(start: 23.0 / 24, end: 7.0 / 24, color: Color(hex: "#7E8AA2")),
        .init(start: 9.0 / 24, end: 12.0 / 24, color: Color(hex: "#C25B4E")),
        .init(start: 13.0 / 24, end: 15.5 / 24, color: Color(hex: "#D8A24A")),
        .init(start: 19.0 / 24, end: 21.0 / 24, color: Color(hex: "#5E8B6A")),
    ]

    var body: some View {
        ZStack {
            theme.color
            OqloqView(
                vm: OqloqViewModel(engine: FixedAngleClockEngine(hour: hour, minute: minute)),
                routines: routines
            )
            .padding(28)
        }
        .overlay(alignment: .bottom) {
            Text(theme.nameKey)
                .font(.caption)
                .foregroundStyle(theme.prefersLightForeground ? .white : .black)
                .padding(6)
        }
    }
}

// All eight walls at the same time with the same routines.
#Preview("Walls – all eight") {
    ScrollView {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: 2), spacing: 2) {
            ForEach(WallTheme.allCases) { theme in
                WallThemeSample(theme: theme)
                    .frame(height: 260)
            }
        }
    }
}

#Preview("Wall – Ivory") { WallThemeSample(theme: .ivory) }
#Preview("Wall – Sand (default)") { WallThemeSample(theme: .sand) }
#Preview("Wall – Sage") { WallThemeSample(theme: .sage) }
#Preview("Wall – Charcoal") { WallThemeSample(theme: .charcoal) }
