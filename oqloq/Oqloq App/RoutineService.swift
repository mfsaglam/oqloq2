//
//  RoutinePersistenceInteractor.swift
//  oqloq
//
//  Created by Fatih Sağlam on 31.08.2024.
//

import Foundation

protocol RoutineService {
    func saveRoutine(routine: RoutineDTO) throws
    func loadRoutines() throws -> [RoutineDTO]
    func deleteRoutine(_ routine: RoutineDTO) throws
}
