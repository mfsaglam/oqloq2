//
//  SwiftDataRoutineService.swift
//  oqloq
//

import Foundation
import SwiftData

/// SwiftData backed `RoutineService`.
///
/// Every failure is thrown rather than trapped, so callers can report a
/// failed save instead of crashing or silently losing the routine.
final class SwiftDataRoutineService: RoutineService {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func saveRoutine(routine: RoutineDTO) throws {
        context.insert(
            RoutineEntity(
                id: routine.id,
                startTime: routine.startTime,
                endTime: routine.endTime,
                color: routine.color
            )
        )
        try context.save()
    }

    /// Sorted by start time so ordering is deterministic, which both the
    /// drawing order of overlapping arcs and `CreateRoutineViewModel`'s
    /// "continue from the last routine" prefill depend on.
    func loadRoutines() throws -> [RoutineDTO] {
        let descriptor = FetchDescriptor<RoutineEntity>(
            sortBy: [SortDescriptor(\.startTime)]
        )
        return try context.fetch(descriptor).map { $0.asDto }
    }

    func deleteRoutine(_ routine: RoutineDTO) throws {
        // Filtered in memory rather than with #Predicate: the set is one
        // day's routines, and UUID comparison in SwiftData predicates is
        // more trouble than a linear scan of a handful of rows.
        let all = try context.fetch(FetchDescriptor<RoutineEntity>())
        guard let entity = all.first(where: { $0.id == routine.id }) else { return }
        context.delete(entity)
        try context.save()
    }
}
