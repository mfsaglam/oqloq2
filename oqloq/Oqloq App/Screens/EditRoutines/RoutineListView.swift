//
//  RoutineListView.swift
//  oqloq
//
//  Created by Saglam, Fatih on 14.08.2024.
//

import SwiftUI

struct RoutineListView: View {
    let startTime: String
    let endTime: String
    let color: Color
    var body: some View {
        HStack {
            Circle()
                .frame(width: 20)
                .foregroundStyle(color)
            Spacer()
            Text("\(startTime) - \(endTime)")
            
        }
    }
}

#Preview {
    RoutineListView(
        startTime: "13:00",
        endTime: "21:00",
        color: .blue
    )
}
