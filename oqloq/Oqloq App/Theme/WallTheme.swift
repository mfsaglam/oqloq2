//
//  WallTheme.swift
//  oqloq
//

import SwiftUI

/// A painted wall the clock hangs on.
///
/// The `rawValue` is a stable identifier and is what gets persisted; the hex
/// values are design starting points and may be retuned without invalidating
/// anyone's stored preference. SwiftUI `Color` is never serialised.
enum WallTheme: String, CaseIterable, Identifiable {
    case ivory
    case sand
    case sage
    case mist
    case blush
    case clay
    case stone
    case charcoal

    /// Used for a fresh install and whenever a stored identifier is unknown.
    static let fallback: WallTheme = .sand

    var id: String { rawValue }

    var hex: String {
        switch self {
        case .ivory: return "#F1EEE6"
        case .sand: return "#DFCEB6"
        case .sage: return "#BCCBB9"
        case .mist: return "#B7C9D7"
        case .blush: return "#E3C6C2"
        case .clay: return "#C7987D"
        case .stone: return "#CECFCA"
        case .charcoal: return "#484A4D"
        }
    }

    var color: Color { Color(hex: hex) ?? .unreadable }

    /// Key into `Localizable.xcstrings`.
    var nameKey: LocalizedStringKey { LocalizedStringKey("wallTheme_\(rawValue)") }

    /// Whether this wall is dark enough that text drawn on it needs to be
    /// light. Only Charcoal is, but derived rather than hard-coded so
    /// retuning a hex cannot silently break contrast.
    var prefersLightForeground: Bool { Self.relativeLuminance(of: hex) < 0.5 }

    /// Rough perceptual luminance, enough to choose between dark and light
    /// foreground on these eight swatches.
    static func relativeLuminance(of hex: String) -> Double {
        var text = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.hasPrefix("#") { text.removeFirst() }
        guard text.count == 6, let value = UInt64(text, radix: 16) else { return 1 }
        let red = Double((value & 0xFF0000) >> 16) / 255
        let green = Double((value & 0x00FF00) >> 8) / 255
        let blue = Double(value & 0x0000FF) / 255
        return 0.2126 * red + 0.7152 * green + 0.0722 * blue
    }
}
