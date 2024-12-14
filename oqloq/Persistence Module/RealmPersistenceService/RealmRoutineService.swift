//
//  AnyPersistenceInteractor.swift
//  oqloq
//
//  Created by Saglam, Fatih on 10.08.2024.
//

import Foundation
import RealmSwift

class RoutineModel: Object {
    @Persisted(primaryKey: true) var id: UUID = UUID()
    @Persisted var startTime: Date
    @Persisted var endTime: Date
    @Persisted var color: String
}

extension RoutineModel {
    var asDto: RoutineDTO {
        return .init(
            id: self.id,
            startTime: self.startTime,
            endTime: self.endTime,
            color: self.color
        )
    }
}

class RealmRoutineService: RoutineService {
    let realm = try! Realm()

    func saveRoutine(routine: RoutineDTO) throws {
        let model = RoutineModel()
        model.id = routine.id
        model.startTime = routine.startTime
        model.endTime = routine.endTime
        model.color = routine.color
        try! realm.write {
            realm.add(model)
        }
    }

    func loadRoutines() throws -> [RoutineDTO] {
        let routines = realm.objects(RoutineModel.self)
        return Array(routines).map { $0.asDto }
    }

    func deleteRoutine(_ routine: RoutineDTO) throws {
        if let routineToDelete = realm.object(ofType: RoutineModel.self, forPrimaryKey: routine.id) {
            try realm.write {
                realm.delete(routineToDelete)
            }
        }
    }
}

// data migration helpers

func getSharedRealmConfig() -> Realm.Configuration {
    guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.mfsaglam.routineClock") else {
        fatalError("Unable to find app group container")
    }
    let realmURL = containerURL.appendingPathComponent("default.realm")
    var config = Realm.Configuration()
    config.fileURL = realmURL
    return config
}

func migrateRealmToSharedContainer() {
    let defaultRealmURL = Realm.Configuration.defaultConfiguration.fileURL!
    guard let sharedContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.mfsaglam.routineClock") else {
        fatalError("Unable to find app group container")
    }
    let sharedRealmURL = sharedContainerURL.appendingPathComponent("default.realm")
    let fileManager = FileManager.default

    // Check if the shared Realm already exists
    if fileManager.fileExists(atPath: sharedRealmURL.path) {
        print("Shared Realm already exists, no migration needed.")
        return
    }

    do {
        // Move the Realm file to the shared container
        try fileManager.moveItem(at: defaultRealmURL, to: sharedRealmURL)
        print("Realm migrated successfully to shared container.")
    } catch {
        print("Error migrating Realm: \(error)")
    }
}

func setSharedRealmAsDefault() {
    Realm.Configuration.defaultConfiguration = getSharedRealmConfig()
}
