//
//  LightSource.swift
//  oqloq
//

import SwiftUI

/// Where the light falling on the scene comes from.
///
/// One value drives every lit detail, so they cannot drift apart: the
/// direction a shadow falls, how long it is, and which side of the face
/// catches the highlight. Moving the light moves all of them together.
///
/// This is deliberately a plain value, not a lighting engine. When daylight
/// becomes time-dependent, that work produces a `LightSource` for a given
/// hour and everything downstream follows, including a window projection,
/// which must travel in the same direction as the shadows to be believable.
struct LightSource: Equatable {
    /// The direction the light arrives *from*, measured clockwise from
    /// straight above. 0° is directly overhead, 90° from the right, 270°
    /// from the left.
    var azimuth: Angle

    /// How high the light is. 1 is head on and gives short, tight shadows;
    /// 0 grazes the wall and gives long ones.
    var elevation: Double

    /// Late morning sun, high and slightly to the left. The face's highlight
    /// has always sat at -30°, which is this same direction.
    static let `default` = LightSource(azimuth: .degrees(330), elevation: 0.55)

    /// Unit vector in view coordinates, where y grows downward, pointing
    /// where shadows fall: directly away from the light.
    ///
    /// Light from the upper left (330°) therefore throws shadows to the
    /// lower right.
    var shadowDirection: CGSize {
        CGSize(width: -sin(azimuth.radians), height: cos(azimuth.radians))
    }

    /// Offset for a shadow cast by an object of `diameter`. `spread` is the
    /// shadow's base length as a fraction of that diameter; shadows lengthen
    /// as the light drops toward the horizon.
    func shadowOffset(diameter: CGFloat, spread: CGFloat) -> CGSize {
        let length = diameter * spread * CGFloat(0.5 + (1 - elevation))
        return CGSize(
            width: length * shadowDirection.width,
            height: length * shadowDirection.height
        )
    }

    /// Rotation that turns a top-anchored gradient so its highlight faces the
    /// light. Applied to the clock face, this keeps the lit side of the disc
    /// on the same side as the light throwing the shadow.
    var highlightRotation: Angle { azimuth }
}
