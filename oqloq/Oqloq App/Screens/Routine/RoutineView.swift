//
//  RoutineView.swift
//  oqloq
//
//  Created by Saglam, Fatih on 16.07.2024.
//

import SwiftUI

/// One routine drawn as an arc of the 24 hour ring.
///
/// `diameter` and `lineWidth` come from the clock that owns this view, so the
/// arcs always sit exactly on its ring. They used to be derived from the
/// screen width independently, which left the widget's arcs on a different
/// circle from the widget's own ring.
struct RoutineView: View {
    let routine: PresentableRoutine
    let diameter: CGFloat
    let lineWidth: CGFloat
    var light: LightSource = .default

    var body: some View {
        switch routine.arcs {
        case .empty:
            EmptyView()
        case let .single(from, to):
            arc(from: from, to: to)
        case let .split(from, to, thenTo):
            ZStack {
                arc(from: from, to: to)
                arc(from: 0, to: thenTo)
            }
        }
    }

    private func arc(from start: CGFloat, to end: CGFloat) -> some View {
        TubeArc(
            start: start,
            end: end,
            diameter: diameter,
            lineWidth: lineWidth,
            color: routine.color,
            light: light
        )
    }
}

#Preview {
    RoutineView(routine: .init(start: 0.95, end: 0.3, color: .red), diameter: 300, lineWidth: 4)
}
