//
//  RealmToSwiftDataMigrationTests.swift
//  oqloqTests
//

import XCTest
import SwiftData
import RealmSwift
@testable import oqloq

final class RealmToSwiftDataMigrationTests: XCTestCase {

    private var scratch: URL!
    private var defaults: UserDefaults!

    override func setUpWithError() throws {
        scratch = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("migration-tests-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: scratch, withIntermediateDirectories: true)
        // An isolated suite so the completion flag never leaks between tests
        // or touches the real app's preferences.
        defaults = UserDefaults(suiteName: "migration-tests-\(UUID().uuidString)")!
    }

    override func tearDownWithError() throws {
        try? FileManager.default.removeItem(at: scratch)
    }

    private func makeContext() throws -> ModelContext {
        let container = try ModelContainer(
            for: RoutineEntity.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        return ModelContext(container)
    }

    /// Writes a legacy Realm file containing `routines` and returns its URL.
    private func makeLegacyRealm(_ routines: [(UUID, Int, Int, String)]) throws -> URL {
        let url = scratch.appendingPathComponent("legacy-\(UUID().uuidString).realm")
        var configuration = Realm.Configuration()
        configuration.fileURL = url
        configuration.objectTypes = [RoutineModel.self]
        let realm = try Realm(configuration: configuration)
        try realm.write {
            for (id, startHour, endHour, color) in routines {
                let model = RoutineModel()
                model.id = id
                model.startTime = Calendar.current.date(bySettingHour: startHour, minute: 0, second: 0, of: Date())!
                model.endTime = Calendar.current.date(bySettingHour: endHour, minute: 0, second: 0, of: Date())!
                model.color = color
                realm.add(model)
            }
        }
        return url
    }

    func test_copiesLegacyRoutinesIntoSwiftData() throws {
        let context = try makeContext()
        let id = UUID()
        let legacy = try makeLegacyRealm([(id, 9, 11, "#00ff00")])

        let report = try RealmToSwiftDataMigration.runIfNeeded(
            context: context, defaults: defaults, legacyFileURL: legacy
        )

        XCTAssertEqual(report?.copied, 1)
        let migrated = try context.fetch(FetchDescriptor<RoutineEntity>())
        XCTAssertEqual(migrated.map(\.id), [id])
        XCTAssertEqual(migrated.first?.color, "#00ff00")
        XCTAssertEqual(Calendar.current.component(.hour, from: migrated[0].startTime), 9)
        XCTAssertEqual(Calendar.current.component(.hour, from: migrated[0].endTime), 11)
    }

    /// The user's Realm file must survive as a fallback, so the migration
    /// reads a copy and must not modify or delete the original.
    func test_leavesLegacyFileInPlace() throws {
        let context = try makeContext()
        let legacy = try makeLegacyRealm([(UUID(), 8, 9, "#112233")])
        let before = try Data(contentsOf: legacy)

        try RealmToSwiftDataMigration.runIfNeeded(
            context: context, defaults: defaults, legacyFileURL: legacy
        )

        XCTAssertTrue(FileManager.default.fileExists(atPath: legacy.path))
        XCTAssertEqual(try Data(contentsOf: legacy), before, "legacy realm file was modified")
    }

    func test_secondRunIsSkipped() throws {
        let context = try makeContext()
        let legacy = try makeLegacyRealm([(UUID(), 9, 10, "#ff0000")])

        _ = try RealmToSwiftDataMigration.runIfNeeded(
            context: context, defaults: defaults, legacyFileURL: legacy
        )
        let second = try RealmToSwiftDataMigration.runIfNeeded(
            context: context, defaults: defaults, legacyFileURL: legacy
        )

        XCTAssertNil(second, "migration ran twice")
        XCTAssertEqual(try context.fetch(FetchDescriptor<RoutineEntity>()).count, 1)
    }

    /// Even if the completion flag were lost, re-running must not duplicate.
    func test_rerunDoesNotDuplicateRoutines() throws {
        let context = try makeContext()
        let id = UUID()
        let legacy = try makeLegacyRealm([(id, 9, 10, "#ff0000")])

        _ = try RealmToSwiftDataMigration.runIfNeeded(
            context: context, defaults: defaults, legacyFileURL: legacy
        )
        defaults.set(false, forKey: RealmToSwiftDataMigration.completionFlagKey)
        let report = try RealmToSwiftDataMigration.runIfNeeded(
            context: context, defaults: defaults, legacyFileURL: legacy
        )

        XCTAssertEqual(report?.copied, 0)
        XCTAssertEqual(try context.fetch(FetchDescriptor<RoutineEntity>()).map(\.id), [id])
    }

    func test_freshInstallNeedsNoMigration() throws {
        let context = try makeContext()

        let report = try RealmToSwiftDataMigration.runIfNeeded(
            context: context, defaults: defaults, legacyFileURL: nil
        )

        XCTAssertNil(report)
        XCTAssertTrue(defaults.bool(forKey: RealmToSwiftDataMigration.completionFlagKey))
        XCTAssertTrue(try context.fetch(FetchDescriptor<RoutineEntity>()).isEmpty)
    }

    /// A routine with a broken colour is still carried over, because the time
    /// block is the real data. It is reported rather than repaired or dropped.
    func test_unparseableColorIsReportedButRoutineIsKept() throws {
        let context = try makeContext()
        let bad = UUID()
        let legacy = try makeLegacyRealm([(bad, 9, 10, ""), (UUID(), 11, 12, "#abcdef")])

        let report = try RealmToSwiftDataMigration.runIfNeeded(
            context: context, defaults: defaults, legacyFileURL: legacy
        )

        XCTAssertEqual(report?.copied, 2)
        XCTAssertEqual(report?.unparseableColors, [bad])
        XCTAssertEqual(try context.fetch(FetchDescriptor<RoutineEntity>()).count, 2)
    }

    /// A failed read must leave the flag unset so a later launch retries,
    /// rather than silently abandoning the user's routines.
    func test_unreadableLegacyFileThrowsAndDoesNotSetFlag() throws {
        let context = try makeContext()
        let bogus = scratch.appendingPathComponent("not-a-realm.realm")
        try Data("this is not a realm file".utf8).write(to: bogus)

        XCTAssertThrowsError(
            try RealmToSwiftDataMigration.runIfNeeded(
                context: context, defaults: defaults, legacyFileURL: bogus
            )
        )
        XCTAssertFalse(defaults.bool(forKey: RealmToSwiftDataMigration.completionFlagKey))
    }

    func test_hexValidation() {
        XCTAssertTrue(RealmToSwiftDataMigration.isParseableHex("#aabbcc"))
        XCTAssertTrue(RealmToSwiftDataMigration.isParseableHex("AABBCC"))
        XCTAssertFalse(RealmToSwiftDataMigration.isParseableHex(""))
        XCTAssertFalse(RealmToSwiftDataMigration.isParseableHex("#abc"))
        XCTAssertFalse(RealmToSwiftDataMigration.isParseableHex("#gghhii"))
    }
}
