//
//  RealmToSwiftDataMigration.swift
//  oqloq
//

import Foundation
import SwiftData

/// One-time copy of the legacy Realm routines into the SwiftData store.
///
/// Design constraints:
/// - The user's Realm file is never written to or deleted. It stays in place
///   as a fallback, so this migration is recoverable.
/// - Routines are copied verbatim, including their colour strings. Nothing is
///   repaired, substituted or invented; unparseable colours are reported
///   instead, because the time block is the real data and dropping a routine
///   would be worse than surfacing an odd colour.
/// - Re-running is harmless: `RoutineEntity.id` is unique, so a repeat
///   migration upserts the same rows rather than duplicating them.
enum RealmToSwiftDataMigration {
    static let completionFlagKey = "com.oqloq.didMigrateRealmToSwiftData"

    struct Report {
        var copied: Int = 0
        /// Routines whose colour is not a 6 digit hex string. They were still
        /// copied; their identifiers are listed so the problem is visible
        /// rather than silent.
        var unparseableColors: [UUID] = []
        var legacyFileURL: URL?
    }

    /// Returns `nil` when no migration was needed, otherwise a report of what
    /// was copied. Throws only if a legacy file exists but could not be read
    /// or written across, so the caller can retry on a later launch rather
    /// than marking the migration done.
    @discardableResult
    static func runIfNeeded(
        context: ModelContext,
        defaults: UserDefaults = .standard,
        legacyFileURL: URL? = LegacyRealmStore.existingFileURL()
    ) throws -> Report? {
        guard !defaults.bool(forKey: completionFlagKey) else { return nil }

        guard let legacyFileURL else {
            // Fresh install: nothing to carry over.
            defaults.set(true, forKey: completionFlagKey)
            return nil
        }

        let legacyRoutines = try LegacyRealmStore.readRoutines(from: legacyFileURL)

        var report = Report()
        report.legacyFileURL = legacyFileURL

        let existing = try context.fetch(FetchDescriptor<RoutineEntity>())
        let existingIDs = Set(existing.map(\.id))

        for routine in legacyRoutines {
            if !isParseableHex(routine.color) {
                report.unparseableColors.append(routine.id)
            }
            guard !existingIDs.contains(routine.id) else { continue }
            context.insert(
                RoutineEntity(
                    id: routine.id,
                    startTime: routine.startTime,
                    endTime: routine.endTime,
                    color: routine.color
                )
            )
            report.copied += 1
        }

        try context.save()
        defaults.set(true, forKey: completionFlagKey)
        return report
    }

    /// Matches what `Color(hex:)` can actually consume: six hex digits, with
    /// an optional leading `#`.
    static func isParseableHex(_ value: String) -> Bool {
        var text = value.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.hasPrefix("#") { text.removeFirst() }
        return text.count == 6 && text.allSatisfy(\.isHexDigit)
    }
}
