//
//  RoutineDTO+Extension.swift
//  oqloq
//
//  Created by Saglam, Fatih on 10.08.2024.
//

import Foundation

extension RoutineDTO {
    var presentable: PresentableRoutine {
        let calendar = Calendar.current
        let startHour = CGFloat(calendar.component(.hour, from: startTime))
        let startMinute = CGFloat(calendar.component(.minute, from: startTime))
        let endHour = CGFloat(calendar.component(.hour, from: endTime))
        let endMinute = CGFloat(calendar.component(.minute, from: endTime))
        
        let start = (startHour + startMinute / 60.0) / 24.0
        let end = (endHour + endMinute / 60.0) / 24.0
        
        return PresentableRoutine(id: id, start: start, end: end, color: .init(hex: color))
    }
}
