//
//  PresentableRoutine.swift
//  oqloq
//
//  Created by Saglam, Fatih on 16.07.2024.
//

import SwiftUI

struct PresentableRoutine: Identifiable {
    let id: UUID
    let start: CGFloat
    let end: CGFloat
    let color: Color
    
    init(
        id: UUID = UUID(),
        start: CGFloat,
        end: CGFloat,
        color: Color
    ) {
        self.id = id
        self.start = start
        self.end = end
        self.color = color
    }
}
