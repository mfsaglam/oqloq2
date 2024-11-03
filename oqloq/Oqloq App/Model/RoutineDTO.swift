//
//  RoutineDTO.swift
//  oqloq
//
//  Created by Fatih Sağlam on 4.08.2024.
//

import Foundation

struct RoutineDTO: Identifiable {
    let id: UUID
    let startTime: Date
    let endTime: Date
    let color: String
    
    init(
        id: UUID = UUID(),
        startTime: Date,
        endTime: Date,
        color: String
    ) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.color = color
    }
}
