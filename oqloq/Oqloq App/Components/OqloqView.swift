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
    private let screenwidth = UIScreen.main.bounds.width
    private let routineWidth = UIScreen.main.bounds.width * 0.0102

    var body: some View {
        ZStack {
            routineBase
            allRoutines
            clock
            indicator
        }
        .shadow(color: .black.opacity(0.3), radius: 30, x: 30, y: 30)
    }
    
    private var routineBase: some View {
        Circle()
            .stroke(lineWidth: routineWidth)
            .foregroundStyle(
                .solidBack.opacity(0.8)
            )
            .blur(radius: 1)
            .frame(height: screenwidth * 0.9)
            .blendMode(.color)
    }
    
    private var allRoutines: some View {
        ForEach(routines) { routine in
            RoutineView(routine: routine)
        }
    }
    
    private var clock: some View {
        ZStack {
            Circle()
                .fill(.solidBack)
                .frame(height: screenwidth * 0.8)
                .rotationEffect(.degrees(-30))
                .padding(.vertical)
            
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.05), .black.opacity(0.2)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: screenwidth * 0.8)
                .rotationEffect(.degrees(-30))
                .padding(.vertical)
        }
    }
    
    private var indicator: some View {
        Circle()
            .trim(from: 0.0, to: 0.002)
            .stroke(.primary, lineWidth: screenwidth * 0.12)
            .frame(height: screenwidth * 0.68)
            .rotationEffect(Angle(degrees: -90))
            .rotationEffect(vm.angle)
            .animation(.easeInOut(duration: 0.5), value: vm.angle)
    }
}

#Preview {
    OqloqView(vm: OqloqViewModel(engine: ClockEngine()), routines: [
        .init(start: 0.9, end: 0.3, color: .red)
    ])
}
