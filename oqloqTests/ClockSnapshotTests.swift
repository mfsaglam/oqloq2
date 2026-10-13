//
//  ClockSnapshotTests.swift
//  oqloqTests
//
//  Renders the home screen for the four comparison themes and attaches the
//  PNGs to the test results, so clock changes can be reviewed visually:
//
//    xcrun xcresulttool export attachments --path <result>.xcresult \
//      --test-id "ClockSnapshotTests/test_renderHomeScreenForEachTheme()" \
//      --output-path <directory>
//

import XCTest
import SwiftUI
@testable import oqloq

@MainActor
final class ClockSnapshotTests: XCTestCase {

    /// The four themes the roadmap asks to compare.
    private let themes: [WallTheme] = [.ivory, .sand, .sage, .charcoal]

    func test_renderHomeScreenForEachTheme() throws {
        let size = UIScreen.main.bounds.size

        for theme in themes {
            let view = SnapshotHome(theme: theme).frame(width: size.width, height: size.height)
            let renderer = ImageRenderer(content: view)
            renderer.scale = 2

            let image = try XCTUnwrap(renderer.uiImage, "could not render \(theme.rawValue)")
            let data = try XCTUnwrap(image.pngData(), "could not encode \(theme.rawValue)")

            let attachment = XCTAttachment(data: data, uniformTypeIdentifier: "public.png")
            attachment.name = "\(theme.rawValue).png"
            attachment.lifetime = .keepAlways
            add(attachment)
        }
    }

    /// The same scene under four sun positions. The cast shadow and the lit
    /// side of the face must always point in opposite directions; if they
    /// ever disagree, it will be obvious here.
    func test_renderLightDirections() throws {
        let positions: [(String, LightSource)] = [
            ("sun-upper-left", LightSource(azimuth: .degrees(315), elevation: 0.70)),
            ("sun-overhead", LightSource(azimuth: .degrees(0), elevation: 0.90)),
            ("sun-upper-right", LightSource(azimuth: .degrees(45), elevation: 0.70)),
            ("sun-low-left", LightSource(azimuth: .degrees(285), elevation: 0.12)),
        ]
        let size = UIScreen.main.bounds.size

        for (name, light) in positions {
            let view = SnapshotHome(theme: .sage, light: light)
                .frame(width: size.width, height: size.height)
            let renderer = ImageRenderer(content: view)
            renderer.scale = 2

            let image = try XCTUnwrap(renderer.uiImage, "could not render \(name)")
            let data = try XCTUnwrap(image.pngData(), "could not encode \(name)")

            let attachment = XCTAttachment(data: data, uniformTypeIdentifier: "public.png")
            attachment.name = "\(name).png"
            attachment.lifetime = .keepAlways
            add(attachment)
        }
    }
}

/// Mirrors `HomeView`'s composition, with the indicator frozen so successive
/// renders are comparable.
private struct SnapshotHome: View {
    let theme: WallTheme
    var light: LightSource = .default

    var body: some View {
        ZStack {
            theme.color
            OqloqView(
                vm: OqloqViewModel(engine: StaticClockEngine(hour: 10, minute: 10)),
                routines: WallThemeSample.sampleRoutines,
                light: light
            )
            .padding()
            .padding(.bottom, 100)
        }
    }
}
