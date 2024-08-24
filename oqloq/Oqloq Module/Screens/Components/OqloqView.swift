//
//  OqloqView.swift
//  oqloq
//
//  Created by Saglam, Fatih on 16.07.2024.
//

import SwiftUI

struct OqloqView: View {
        
    @StateObject var vm = OqloqViewModel(
        engine: ClockEngine()
    )
    
    let routines: [PresentableRoutine]

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .foregroundStyle(
                    .solidBack.opacity(0.3)
                )
                .blur(radius: 1)
                .frame(height: UIScreen.main.bounds.width * 0.9)
                .blendMode(.color)

            ForEach(routines) { routine in
                RoutineView(routine: routine)
            }
            
            Circle()
                .foregroundStyle(.solidBack.gradient)
                .frame(height: UIScreen.main.bounds.width * 0.8)
                .rotationEffect(.degrees(-30))
                .padding(.vertical)
            
            Circle()
                .trim(from: 0.0, to: 0.002)
                .stroke(.primary, lineWidth: 50)
                .frame(height: UIScreen.main.bounds.width * 0.66)
                .rotationEffect(Angle(degrees: -90))
                .rotationEffect(vm.angle)
                .animation(.easeInOut(duration: 0.5), value: vm.angle)

        }
        .shadow(color: .black.opacity(0.3), radius: 30, x: 30, y: 30)
    }
}

#Preview {
    OqloqView(vm: OqloqViewModel(engine: ClockEngine()), routines: [])
}
