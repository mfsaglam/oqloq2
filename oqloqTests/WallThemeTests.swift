//
//  WallThemeTests.swift
//  oqloqTests
//

import XCTest
@testable import oqloq

final class WallThemeTests: XCTestCase {

    private func makeDefaults() -> UserDefaults {
        UserDefaults(suiteName: "wall-theme-tests-\(UUID().uuidString)")!
    }

    func test_thereAreExactlyEightThemes() {
        XCTAssertEqual(WallTheme.allCases.count, 8)
    }

    func test_identifiersAreStable() {
        XCTAssertEqual(
            WallTheme.allCases.map(\.rawValue),
            ["ivory", "sand", "sage", "mist", "blush", "clay", "stone", "charcoal"]
        )
    }

    func test_everyThemeHasASixDigitHex() {
        for theme in WallTheme.allCases {
            XCTAssertTrue(
                theme.hex.hasPrefix("#") && theme.hex.count == 7,
                "\(theme.rawValue) has malformed hex \(theme.hex)"
            )
            XCTAssertTrue(
                theme.hex.dropFirst().allSatisfy(\.isHexDigit),
                "\(theme.rawValue) has non-hex digits in \(theme.hex)"
            )
        }
    }

    func test_everyThemeRoundTripsThroughTheStore() {
        let defaults = makeDefaults()
        for theme in WallTheme.allCases {
            ThemeStore.save(theme, to: defaults)
            XCTAssertEqual(ThemeStore.load(from: defaults), theme)
        }
    }

    func test_absentPreferenceResolvesToFallback() {
        XCTAssertEqual(ThemeStore.load(from: makeDefaults()), .sand)
    }

    /// A renamed or removed theme must never leave the wall unpainted.
    func test_unknownIdentifierResolvesToFallback() {
        let defaults = makeDefaults()
        for raw in ["", "lavender", "IVORY", "  sand  ", "42"] {
            defaults.set(raw, forKey: ThemeStore.storageKey)
            XCTAssertEqual(ThemeStore.load(from: defaults), .sand, "raw value \(raw.debugDescription)")
        }
    }

    func test_wronglyTypedPreferenceResolvesToFallback() {
        let defaults = makeDefaults()
        defaults.set(17, forKey: ThemeStore.storageKey)
        XCTAssertEqual(ThemeStore.load(from: defaults), .sand)
    }

    /// Only Charcoal is dark enough to need a light foreground; this guards
    /// contrast if a hex is retuned later.
    func test_onlyCharcoalPrefersLightForeground() {
        let dark = WallTheme.allCases.filter(\.prefersLightForeground)
        XCTAssertEqual(dark, [.charcoal])
    }
}
