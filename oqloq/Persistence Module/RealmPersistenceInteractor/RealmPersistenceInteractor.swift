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

class RealmPersistenceInteractor: RoutinePersistenceInteractor {
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

    func loadRoutines() -> [RoutineModel] {
        let routines = realm.objects(RoutineModel.self)
        return Array(routines)
    }

    func deleteRoutine(_ routine: RoutineModel) {
        try! realm.write {
            realm.delete(routine)
        }
    }
}
