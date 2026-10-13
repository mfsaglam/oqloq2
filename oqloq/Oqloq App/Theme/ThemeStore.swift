//
//  ThemeStore.swift
//  oqloq
//

import Foundation

extension AppGroup {
    /// Preferences shared with the widget. Falls back to standard defaults so
    /// a missing group degrades to an app-local preference rather than
    /// crashing; the widget would then keep its own default.
    static var sharedDefaults: UserDefaults {
        UserDefaults(suiteName: identifier) ?? .standard
    }
}

/// Reads and writes the selected wall as a stable identifier string.
///
/// Used directly by the widget, which has no SwiftUI environment to read.
/// In the app, views bind to the same key with `@AppStorage`.
enum ThemeStore {
    static let storageKey = "com.oqloq.wallThemeID"

    /// Any unknown, empty or absent identifier resolves to the fallback, so a
    /// renamed or removed theme can never leave the wall unpainted.
    static func load(from defaults: UserDefaults = AppGroup.sharedDefaults) -> WallTheme {
        guard let raw = defaults.string(forKey: storageKey) else { return .fallback }
        return WallTheme(rawValue: raw) ?? .fallback
    }

    static func save(_ theme: WallTheme, to defaults: UserDefaults = AppGroup.sharedDefaults) {
        defaults.set(theme.rawValue, forKey: storageKey)
    }
}
