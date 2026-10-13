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

    var body: some View {
        if routine.start < routine.end {
            arc(from: routine.start, to: routine.end)
        } else {
            // Spans midnight, so it is drawn as two arcs: up to the end of the
            // day, and from the start of the next.
            ZStack {
                arc(from: routine.start, to: 0.9999)
                arc(from: 0, to: routine.end)
            }
        }
    }

    private func arc(from start: CGFloat, to end: CGFloat) -> some View {
        Circle()
            .trim(from: start, to: end)
            .stroke(lineWidth: lineWidth)
            .foregroundStyle(routine.color)
            .frame(width: diameter, height: diameter)
            .rotationEffect(Angle(degrees: -90))
    }
}

#Preview {
    RoutineView(routine: .init(start: 0.95, end: 0.3, color: .red), diameter: 300, lineWidth: 4)
}
