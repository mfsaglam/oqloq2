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
            try autoreleasepool {
                let view = SnapshotHome(theme: theme).frame(width: size.width, height: size.height)
                attach(try png(of: view, name: theme.rawValue), name: theme.rawValue)
            }
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
            try autoreleasepool {
                let view = SnapshotHome(theme: .sage, light: light)
                    .frame(width: size.width, height: size.height)
                attach(try png(of: view, name: name), name: name)
            }
        }
    }

    /// The widget and the app must draw the same object. They are separate
    /// views, so this renders both at the same size with the same inputs and
    /// requires the pixels to match; anything that drifts shows up here
    /// rather than on someone's home screen.
    func test_widgetAndAppClocksRenderIdentically() throws {
        let side: CGFloat = 360
        let angle = StaticClockEngine(hour: 10, minute: 10).currentAngle()
        let routines = WallThemeSample.sampleRoutines

        let appClock = OqloqView(
            vm: OqloqViewModel(engine: StaticClockEngine(hour: 10, minute: 10)),
            routines: routines
        ).frame(width: side, height: side)

        let widgetClock = WidgetClockView(routines: routines, angle: angle)
            .frame(width: side, height: side)

        let app = try render(appClock, name: "parity-app")
        let widget = try render(widgetClock, name: "parity-widget")

        let differing = try Self.differingPixels(app, widget)
        XCTAssertEqual(differing, 0, "widget and app clocks differ in \(differing) pixels")
    }

    private func render(_ view: some View, name: String) throws -> CGImage {
        let image = try image(of: view, name: name)
        attach(try encode(image, name: name), name: name)
        return try XCTUnwrap(image.cgImage)
    }

    private func image(of view: some View, name: String) throws -> UIImage {
        let renderer = ImageRenderer(content: view)
        renderer.scale = 2
        return try XCTUnwrap(renderer.uiImage, "could not render \(name)")
    }

    private func png(of view: some View, name: String) throws -> Data {
        try encode(try image(of: view, name: name), name: name)
    }

    /// PNG encoding of a full screen render can fail transiently when several
    /// have been held at once, so a failure is retried after draining.
    private func encode(_ image: UIImage, name: String) throws -> Data {
        if let data = autoreleasepool(invoking: { image.pngData() }) { return data }
        return try XCTUnwrap(
            autoreleasepool(invoking: { image.pngData() }),
            "could not encode \(name)"
        )
    }

    private func attach(_ data: Data, name: String) {
        let attachment = XCTAttachment(data: data, uniformTypeIdentifier: "public.png")
        attachment.name = "\(name).png"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    /// Number of pixels whose colour differs by more than a rounding step.
    private static func differingPixels(_ a: CGImage, _ b: CGImage) throws -> Int {
        guard a.width == b.width, a.height == b.height else { return .max }
        func bytes(_ image: CGImage) throws -> [UInt8] {
            var buffer = [UInt8](repeating: 0, count: image.width * image.height * 4)
            let context = try XCTUnwrap(CGContext(
                data: &buffer, width: image.width, height: image.height,
                bitsPerComponent: 8, bytesPerRow: image.width * 4,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            ))
            context.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
            return buffer
        }
        let left = try bytes(a), right = try bytes(b)
        var differing = 0
        for index in stride(from: 0, to: left.count, by: 4) where
            abs(Int(left[index]) - Int(right[index])) > 1
            || abs(Int(left[index + 1]) - Int(right[index + 1])) > 1
            || abs(Int(left[index + 2]) - Int(right[index + 2])) > 1 {
            differing += 1
        }
        return differing
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
