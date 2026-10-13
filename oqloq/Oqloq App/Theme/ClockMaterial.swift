//
//  ClockMaterial.swift
//  oqloq
//

import SwiftUI

/// Fixed surface colours for the clock itself.
///
/// The clock is a physical object on a wall, so it does not invert with the
/// system appearance. These belong to the clock's material rather than to the
/// wall, which is why they are constants and not derived from `WallTheme`:
/// the same object should read the same way on all eight walls.
enum ClockMaterial {
    /// The matte face.
    static let face = Color.white

    /// The unpainted part of the routine ring.
    ///
    /// A mid grey rather than a translucent black or white, so it stays
    /// visible on both pale and dark walls. The previous `.blendMode(.color)`
    /// track disappeared entirely on Charcoal.
    static let ringTrack = Color(white: 0.80)

    /// The short indicator at the face's edge. Near black rather than pure
    /// black, which reads slightly softer against the matte face.
    static let indicator = Color(white: 0.10)

    // MARK: Shading
    //
    // All proportional to the clock's diameter so the material looks the same
    // at any size, on a phone or in a widget. Shadow *direction* is not here:
    // it comes from `LightSource`, so it stays in step with the highlight.

    /// Soft light from the lit side, giving the face its gentle falloff.
    /// Deliberately weak: a strong gradient reads as glossy plastic.
    static let faceHighlight = Color.white.opacity(0.5)
    static let faceShade = Color.black.opacity(0.05)
    /// Slight darkening towards the rim, suggesting a disc with thickness.
    static let faceRimShade = Color.black.opacity(0.05)

    /// The shadow the clock throws on the wall. Fairly dark and only lightly
    /// blurred, so it reads as a cast shadow with a direction rather than a
    /// soft glow.
    static let castShadow = Color.black.opacity(0.30)
    static let castShadowRadius: CGFloat = 0.022
    static let castShadowSpread: CGFloat = 0.050

    /// Broad, weak occlusion around the body. Carries no direction of its
    /// own; it only seats the object against the wall.
    static let ambientShadow = Color.black.opacity(0.13)
    static let ambientShadowRadius: CGFloat = 0.075
    static let ambientShadowSpread: CGFloat = 0.012
}
