//
//  ClockFace.swift
//  oqloq
//

import SwiftUI

/// The matte disc, lit from `light`.
///
/// Shared by the app and the widget: it is the clock's material rather than
/// its layout, and both should be made of the same stuff.
struct ClockFace: View {
    let diameter: CGFloat
    var light: LightSource = .default

    var body: some View {
        Circle()
            .fill(ClockMaterial.face)
            .frame(width: diameter, height: diameter)
            .overlay(
                // Soft light from the lit side. Kept weak on purpose: a
                // strong gradient here reads as glossy plastic.
                Circle().fill(
                    LinearGradient(
                        stops: [
                            .init(color: ClockMaterial.faceHighlight, location: 0),
                            .init(color: .clear, location: 0.45),
                            .init(color: ClockMaterial.faceShade, location: 1),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            )
            .overlay(
                // Rim falloff, giving the disc thickness without a specular
                // highlight.
                Circle().fill(
                    RadialGradient(
                        colors: [.clear, ClockMaterial.faceRimShade],
                        center: .center,
                        startRadius: diameter * 0.34,
                        endRadius: diameter * 0.5
                    )
                )
            )
            .overlay(
                Circle().strokeBorder(
                    LinearGradient(
                        colors: [.white.opacity(0.85), .black.opacity(0.07)],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: max(1, diameter * 0.005)
                )
            )
            // Turns the whole shading so the lit side faces the light.
            .rotationEffect(light.highlightRotation)
    }
}
