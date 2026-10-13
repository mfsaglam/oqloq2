//
//  TubeArc.swift
//  oqloq
//

import SwiftUI

/// An arc of the ring, drawn as a length of plastic tube.
///
/// The tube is round in cross section, so it carries a bright specular band
/// along its outer edge and a darker band along its inner one. Both vary
/// around the ring with the light: strongest where the tube faces the light,
/// weakest where it faces away. Together they give the ring volume without
/// changing its width or its colour.
struct TubeArc: View {
    let start: CGFloat
    let end: CGFloat
    let diameter: CGFloat
    let lineWidth: CGFloat
    let color: Color
    var light: LightSource = .default

    var body: some View {
        ZStack {
            band(diameter: diameter, width: lineWidth, style: color)

            band(
                diameter: diameter - lineWidth * ClockMaterial.tubeShadeInset,
                width: lineWidth * ClockMaterial.tubeShadeWidth,
                style: angular(ClockMaterial.tubeShadeLit, ClockMaterial.tubeShadeUnlit)
            )

            band(
                diameter: diameter + lineWidth * ClockMaterial.tubeHighlightInset,
                width: lineWidth * ClockMaterial.tubeHighlightWidth,
                style: angular(ClockMaterial.tubeHighlightLit, ClockMaterial.tubeHighlightUnlit)
            )
        }
        // Keeps the two bands inside the tube's own silhouette.
        .mask(band(diameter: diameter, width: lineWidth, style: Color.black))
    }

    private func band(diameter: CGFloat, width: CGFloat, style: some ShapeStyle) -> some View {
        Circle()
            .trim(from: start, to: end)
            .stroke(style, lineWidth: width)
            .frame(width: diameter, height: diameter)
            .rotationEffect(.degrees(ClockGeometry.originRotation))
    }

    /// Peaks in the direction the light comes from and falls off opposite.
    ///
    /// The gradient is laid out before the arc's quarter turn, and that turn
    /// rotates it too, which is why the angle here is the azimuth itself
    /// rather than the azimuth less a quarter.
    private func angular(_ lit: Color, _ unlit: Color) -> AngularGradient {
        AngularGradient(
            stops: [
                .init(color: lit, location: 0.0),
                .init(color: unlit, location: 0.5),
                .init(color: lit, location: 1.0),
            ],
            center: .center,
            angle: light.azimuth
        )
    }
}
