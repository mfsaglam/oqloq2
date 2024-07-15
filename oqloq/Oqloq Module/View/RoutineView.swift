//
//  RoutineView.swift
//  oqloq
//
//  Created by Saglam, Fatih on 16.07.2024.
//

import SwiftUI

struct RoutineView: View {
    
    let routine: PresentableRoutine
    
    var body: some View {
        Circle()
            .trim(from: CGFloat(routine.start), to: CGFloat(routine.end))
            .stroke(lineWidth: 4)
            .foregroundStyle(routine.color)
            .frame(height: UIScreen.main.bounds.width * 0.9)
            .rotationEffect(Angle(degrees: -90))
    }
}

#Preview {
    RoutineView(routine: .init(start: 0, end: 0.3, color: .red))
}
