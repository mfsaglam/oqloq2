//
//  LegacyRealmStore.swift
//  oqloq
//
//  Read-only access to the pre-SwiftData Realm store, used solely to migrate
//  existing users' routines. Compiled into the app target only; the widget
//  never touches Realm.
//

import Foundation
import RealmSwift

/// The legacy Realm object. Must keep the original class name and property
/// names, because that is how the data is stored on existing devices.
final class RoutineModel: Object {
    @Persisted(primaryKey: true) var id: UUID = UUID()
    @Persisted var startTime: Date
    @Persisted var endTime: Date
    @Persisted var color: String
}

enum LegacyRealmStore {
    /// Candidate locations for an existing Realm file, newest layout first.
    ///
    /// Shipped versions moved the file from the app sandbox into the app
    /// group container, but a user who never ran such a version still has it
    /// at the original default location, so both are checked.
    static func existingFileURL() -> URL? {
        var candidates: [URL] = []
        if let group = try? AppGroup.containerURL() {
            candidates.append(group.appendingPathComponent("default.realm"))
        }
        if let defaultURL = Realm.Configuration().fileURL {
            candidates.append(defaultURL)
        }
        return candidates.first { FileManager.default.fileExists(atPath: $0.path) }
    }

    /// Reads every routine from `url` without modifying the file at `url`.
    ///
    /// Realm cannot upgrade a file's format while it is open read-only, and
    /// this store predates the realm-core 20 format, so opening the original
    /// in place would force a one-way upgrade. Instead the file is copied to
    /// a temporary directory and the *copy* is opened and upgraded, leaving
    /// the user's original file untouched and recoverable.
    static func readRoutines(from url: URL) throws -> [RoutineDTO] {
        let scratch = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("oqloq-realm-migration-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: scratch, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: scratch) }

        let copyURL = scratch.appendingPathComponent("default.realm")
        try FileManager.default.copyItem(at: url, to: copyURL)

        var configuration = Realm.Configuration()
        configuration.fileURL = copyURL
        // Deliberately writable: the copy may need a format upgrade to be
        // readable at all. Only the copy is ever modified.
        configuration.readOnly = false
        configuration.objectTypes = [RoutineModel.self]

        let realm = try Realm(configuration: configuration)
        return realm.objects(RoutineModel.self).map {
            RoutineDTO(id: $0.id, startTime: $0.startTime, endTime: $0.endTime, color: $0.color)
        }
    }
}
