//
//  ClockGeometry.swift
//  oqloq
//

import Foundation

/// The clock's proportions, as fractions of its overall diameter.
///
/// Shared by the app's clock and the widget's own clock. The two draw
/// themselves separately so each can be tuned for its own canvas, but they
/// read their proportions from here: when they each carried their own
/// numbers, the widget's arcs ended up on a different circle from the
/// widget's ring, by a device dependent amount.
enum ClockGeometry {
    /// Outer ring carrying the routine arcs.
    static let ring: CGFloat = 0.9
    static let ringStroke: CGFloat = 0.0102

    /// The clock face.
    static let face: CGFloat = 0.75

    /// The indicator sits on this circle, its stroke reaching outward almost
    /// to the face's rim. It is not a hand from the centre.
    static let indicatorRing: CGFloat = 0.63
    static let indicatorLength: CGFloat = 0.12
    static let indicatorWidth: CGFloat = 0.002

    /// Trim starts at 3 o'clock, so everything is turned back a quarter turn
    /// to put midnight at the top.
    static let originRotation: Double = -90
}
