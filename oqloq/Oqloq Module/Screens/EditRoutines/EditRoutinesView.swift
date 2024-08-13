//
//  EditRoutinesView.swift
//  oqloq
//
//  Created by Saglam, Fatih on 14.08.2024.
//

import SwiftUI

struct EditRoutinesView: View {
    private let routines: [RoutineDTO] = [
        .init(startTime: .thirteenOClock, endTime: .twentyOneOClock, color: "#0000FF"),
        .init(startTime: .thirteenOClock, endTime: .twentyOneOClock, color: "#0000FF"),
        .init(startTime: .thirteenOClock, endTime: .twentyOneOClock, color: "#0000FF"),
        .init(startTime: .thirteenOClock, endTime: .twentyOneOClock, color: "#0000FF"),
        .init(startTime: .thirteenOClock, endTime: .twentyOneOClock, color: "#0000FF")
    ]
    var body: some View {
        List {
            ForEach(routines) { routine in
                RoutineListView(
                    startTime: routine.startTime.formattedTime(),
                    endTime: routine.endTime.formattedTime(),
                    color: .init(hex: routine.color)
                )
            }
            .onDelete(perform: deleteRoutine)
        }
    }
    
    func deleteRoutine(at offsets: IndexSet) {
        // show alert to make sure
        // vm.delete(atOffsets: offsets)
    }
    
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
}

extension Date {
    static var thirteenOClock: Date {
        return Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: Date())!
    }
    
    static var twentyOneOClock: Date {
        return Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: Date())!
    }
    
    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}

#Preview {
    EditRoutinesView()
}
