//
//  EditRoutinesViewModel.swift
//  oqloq
//
//  Created by Fatih Sağlam on 31.08.2024.
//

import Foundation

class EditRoutinesViewModel: ObservableObject {
    @Published var routines: [RoutineDTO] = []
    
    private let interactor: RoutineService
    
    init(interactor: RoutineService) {
        self.interactor = interactor
    }
    
    func loadRoutines() {
        do {
            let data = try interactor.loadRoutines()
            routines = data
        } catch {
            print("[oqloq] Could not load routines: \(error)")
        }
    }
    
    func delete(atOffsets indexSet: IndexSet) {
        do {
            try indexSet.forEach { index in
                try deleteRoutine(at: index)
            }
            routines.remove(atOffsets: indexSet)
        } catch {
            print("[oqloq] Could not delete routine: \(error)")
        }
    }
    
    func deleteAllRoutines() {
        do {
            try routines.indices.forEach { index in
                try deleteRoutine(at: index)
            }
            // The published list was left holding the deleted routines, which
            // only went unnoticed because the screen dismisses afterwards.
            routines.removeAll()
        } catch {
            print("[oqloq] Could not delete every routine: \(error)")
        }
    }
    
    private func deleteRoutine(at index: IndexSet.Element) throws {
        let routine = routines[index]
        try interactor.deleteRoutine(routine)
    }
}
