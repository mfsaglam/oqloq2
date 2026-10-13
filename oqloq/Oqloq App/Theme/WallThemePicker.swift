//
//  WallThemePicker.swift
//  oqloq
//

import SwiftUI
import WidgetKit

/// Eight fixed wall swatches. No free colour picker: the wall is a curated
/// material, unlike a routine's colour, which stays user-chosen.
struct WallThemePicker: View {
    @AppStorage(ThemeStore.storageKey, store: AppGroup.sharedDefaults)
    private var storedThemeID: String = WallTheme.fallback.rawValue

    private var selection: WallTheme {
        WallTheme(rawValue: storedThemeID) ?? .fallback
    }

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(WallTheme.allCases) { theme in
                Button {
                    select(theme)
                } label: {
                    swatch(for: theme)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(Text(theme.nameKey))
                .accessibilityAddTraits(theme == selection ? [.isButton, .isSelected] : .isButton)
            }
        }
        .padding(.vertical, 4)
    }

    private func swatch(for theme: WallTheme) -> some View {
        let isSelected = theme == selection
        return VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(theme.color)
                    .overlay(
                        // Keeps the palest walls from disappearing into the
                        // form background.
                        Circle().strokeBorder(.black.opacity(0.12), lineWidth: 1)
                    )
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(theme.prefersLightForeground ? .white : .black)
                }
            }
            .frame(height: 44)
            .overlay(
                Circle()
                    .strokeBorder(Color.accentColor, lineWidth: isSelected ? 2 : 0)
            )

            Text(theme.nameKey)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }

    private func select(_ theme: WallTheme) {
        storedThemeID = theme.rawValue
        // The widget reads the same key. WidgetKit decides when to redraw, so
        // this is a request, not a guarantee of an immediate update.
        WidgetCenter.shared.reloadAllTimelines()
    }
}

#Preview {
    Form {
        Section(header: Text("editRoutines_wall")) {
            WallThemePicker()
        }
    }
}
