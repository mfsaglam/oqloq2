//
//  ClockMaterial.swift
//  oqloq
//

import SwiftUI

/// Fixed surface colours for the clock itself.
///
/// The clock is a physical object on a wall, so it does not invert with the
/// system appearance. These values match what the old adaptive `solidBack`
/// and `.primary` produced in light mode, so the light-mode look is
/// unchanged; what goes away is the dark-mode flip, which turned the disc
/// near-black and the indicator white on top of a pale wall.
///
/// Refining these into a genuinely matte material is the clock polish phase;
/// this type exists so there is one place to do it.
enum ClockMaterial {
    /// The clock face.
    static let face = Color.white
    /// The short indicator at the face's edge.
    static let indicator = Color.black
}
