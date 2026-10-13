//
//  PresentableRoutine.swift
//  oqloq
//
//  Created by Saglam, Fatih on 16.07.2024.
//

import SwiftUI

struct PresentableRoutine: Identifiable {
    let id: UUID
    let start: CGFloat
    let end: CGFloat
    let color: Color
    
    init(
        id: UUID = UUID(),
        start: CGFloat,
        end: CGFloat,
        color: Color
    ) {
        self.id = id
        self.start = start
        self.end = end
        self.color = color
    }
}

extension PresentableRoutine {
    /// How a routine is laid out on the 24 hour ring.
    ///
    /// The rule for equal start and end used to be an accident: the drawing
    /// code asked whether start was less than end, and if it was not, assumed
    /// the routine crossed midnight. A routine of 09:00 to 09:00 therefore
    /// painted the entire day. It allocates no time, so it now draws nothing.
    enum Arcs: Equatable {
        /// Start and end are the same instant: no time allocated.
        case empty
        case single(from: CGFloat, to: CGFloat)
        /// Crosses midnight, so it is drawn as two arcs.
        case split(from: CGFloat, to: CGFloat, thenTo: CGFloat)
    }

    var arcs: Arcs {
        if start == end { return .empty }
        if start < end { return .single(from: start, to: end) }
        // Stops a hair short of a full turn: trimming to exactly 1 closes the
        // circle and swallows the gap the second arc needs.
        return .split(from: start, to: 0.9999, thenTo: end)
    }
}
