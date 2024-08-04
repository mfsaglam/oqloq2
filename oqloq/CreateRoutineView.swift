//
//  CreateRoutineView.swift
//  oqloq
//
//  Created by Fatih Sağlam on 4.08.2024.
//

import SwiftUI

struct CreateRoutineView: View {
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var routineColor = Color.red

    var body: some View {
        ZStack {
            Form {
                Section(header: Text("Routine time")) {
                    VStack {
                        DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                        DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                    }
                }
                
                Section(header: Text("Routine color")) {
                    ColorPicker("Color", selection: $routineColor)
                }
            }
            VStack {
                Spacer()
                Button(action: {
                    // Action for the button
                    print("Button tapped")
                }) {
                    Label("Save", systemImage: "square.and.arrow.down")
                }
                .padding()
                
                Button(action: {
                    // Action for the button
                    print("cancel Button tapped")
                }) {
                    Label("Cancel", systemImage: "square.and.arrow.down")
                }
                .padding()
            }
        }
    }
}

#Preview {
    CreateRoutineView()
}
