//
//  RoutineView.swift
//  oqloq
//
//  Created by Saglam, Fatih on 16.07.2024.
//

import SwiftUI

struct RoutineView: View {
    
    let routine: PresentableRoutine
    private let screenWidth = UIScreen.main.bounds.width
    private let routineWidth = UIScreen.main.bounds.width * 0.0102
    
    var body: some View {
        if routine.start < routine.end {
            Circle()
                .trim(from: CGFloat(routine.start), to: CGFloat(routine.end))
                .stroke(lineWidth: routineWidth)
                .foregroundStyle(routine.color)
                .frame(height: screenWidth * 0.9)
                .rotationEffect(Angle(degrees: -90))
        } else {
            ZStack {
                Circle()
                    .trim(from: routine.start, to: 0.9999)
                    .stroke(lineWidth: routineWidth)
                    .foregroundStyle(routine.color)
                    .frame(height: screenWidth * 0.9)
                    .rotationEffect(Angle(degrees: -90))
                
                Circle()
                    .trim(from: 0, to: routine.end)
                    .stroke(lineWidth: routineWidth)
                    .foregroundStyle(routine.color)
                    .frame(height: screenWidth * 0.9)
                    .rotationEffect(Angle(degrees: -90))
                
            }
        }
    }
}

#Preview {
    RoutineView(routine: .init(start: 0.95, end: 0.3, color: .red))
}
