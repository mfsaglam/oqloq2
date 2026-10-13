//
//  RoutineEntity.swift
//  oqloq
//

import Foundation
import SwiftData

/// SwiftData representation of a routine.
///
/// Only the start and end *time of day* is meaningful; the date component is
/// ignored when drawing, because the same day repeats.
@Model
final class RoutineEntity {
    /// Stable identity, independent of `color`: the same colour may be reused
    /// across blocks, so identity can never be derived from it. Unique so a
    /// repeated insert of the same routine cannot duplicate it.
    @Attribute(.unique) var id: UUID
    var startTime: Date
    var endTime: Date
    /// Hex string such as `#ff0000`. Stored verbatim as the user's data; this
    /// type does not validate or rewrite it.
    var color: String

    init(id: UUID = UUID(), startTime: Date, endTime: Date, color: String) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.color = color
    }
}

extension RoutineEntity {
    var asDto: RoutineDTO {
        .init(id: id, startTime: startTime, endTime: endTime, color: color)
    }
}
