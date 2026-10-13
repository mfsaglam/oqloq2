//
//  Color+Extension.swift
//  oqloq
//
//  Created by Fatih Sağlam on 4.08.2024.
//

import SwiftUI

extension Color {
    /// Reads `#rrggbb` or `rrggbb`, returning nil for anything else.
    ///
    /// This used to assert on bad input, which trapped the app in Debug and
    /// silently produced a wrong colour in Release. Stored routine colours
    /// are user data and can be malformed, so callers decide what to show
    /// instead of the app deciding to crash.
    init?(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        guard hexString.count == 6, hexString.allSatisfy(\.isHexDigit) else { return nil }

        var rgbValue: UInt64 = 0
        guard Scanner(string: hexString).scanHexInt64(&rgbValue) else { return nil }

        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }

    /// Stand-in for a stored colour that cannot be read. A dull neutral on
    /// purpose: it should look wrong rather than pass for a chosen colour.
    static let unreadable = Color(white: 0.55)

    /// Writes `#rrggbb`, or nil if the colour has no RGB representation.
    func toHex() -> String? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }

        // Rounded, not truncated. Truncating lost a step on most channels,
        // because 51/255 is 0.2, and 0.2 * 255 is 50.999... in binary, so
        // #3366cc was stored as #3266cc. Clamped too, since a wide gamut
        // colour can report components outside 0...1.
        func channel(_ value: CGFloat) -> Int {
            Int((min(max(value, 0), 1) * 255).rounded())
        }

        return String(format: "#%02x%02x%02x", channel(red), channel(green), channel(blue))
    }

    static var random: Color {
        let preDefinedColors: [Color] = [
            .red,
            .green,
            .blue,
            .yellow,
            .brown,
            .purple,
            .orange,
            .pink,
            .cyan,
            .gray,
            .indigo,
            .mint,
            .teal,
        ]
        
        return preDefinedColors.randomElement() ?? .red
    }
}
