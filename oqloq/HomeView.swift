//
//  ContentView.swift
//  oqloq
//
//  Created by Saglam, Fatih on 15.07.2024.
//

import SwiftUI

class HomeViewViewModel: ObservableObject {
    @Published var sample: [PresentableRoutine] = [
        .init(start: 0, end: 0.3, color: .red),
        .init(start: 0.3, end: 0.5, color: .blue),
        .init(start: 0.5, end: 0.6, color: .green),
        .init(start: 0.6, end: 1, color: .white)
    ]
    
    let sampleSample: [RoutineDTO] = [
        .init(
            startTime: .init(timeIntervalSince1970: 1721080800),
            endTime: .init(timeIntervalSince1970: 1721098800),
            color: .red
        ),
        .init(
            startTime: .init(timeIntervalSince1970: 1721098800),
            endTime: .init(timeIntervalSince1970: 1721113200),
            color: .blue
        ),
        .init(
            startTime: .init(timeIntervalSince1970: 1721113200),
            endTime: .init(timeIntervalSince1970: 1721131200),
            color: .green
        ),
        .init(
            startTime: .init(timeIntervalSince1970: 1721131200),
            endTime: .init(timeIntervalSince1970: 1721174400),
            color: .white
        )
    ]
    
    var sampleCount = 0
    
    func addData() {
        if sample.count < 4{
            sample.append(sampleSample[sampleCount].presentable)
            sampleCount += 1
        } else {
            sample.removeAll()
            sampleCount = 0
        }
    }
}

struct HomeView: View {
    
    @StateObject var vm = HomeViewViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.yellow
                    .ignoresSafeArea()
                
                VStack {
                    
                    OqloqView(routines: vm.sample)
                        .padding()
                    
                    Text("Routine Name")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                }
            }
        }
        .toolbarTitleDisplayMode(.inline)
        .navigationTitle("oqloq")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Edit") {
                    vm.addData()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    Text("lol")
                } label: {
                    Label(
                        title: { Text("") },
                        icon: { Image(systemName: "plus") }
                    )
                }
            }
        }
    }
}

struct OqloqView: View {
        
    @StateObject var vm = OqloqViewViewModel(
        engine: ClockEngine()
    )
    
    let routines: [PresentableRoutine]

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .foregroundStyle(
                    .white.opacity(0.3)
                )
                .blur(radius: 1)
                .frame(height: UIScreen.main.bounds.width * 0.9)
                .blendMode(.color)
            

            ForEach(routines) { routine in
                RoutineView(routine: routine)
            }


            
            
            Circle()
                .foregroundStyle(
                    .linearGradient(
                        .init(
                            colors: [.white, .gray]
                        ),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: UIScreen.main.bounds.width * 0.8)
                .rotationEffect(.degrees(30))
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

class OqloqViewViewModel: ObservableObject {
    @Published var angle: Angle = .init(degrees: .zero)
    let engine: ClockEngineInterface
    init(engine: ClockEngineInterface) {
        self.engine = engine
        updateAngle()
        updateAnglePeriodically()
    }
    
    private func updateAngle() {
        angle = engine.getCurrentHourInMinutes().angle()
    }
    
    private func updateAnglePeriodically() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.updateAngle()
        }
    }
}

extension Int {
    func angle() -> Angle {
        return .init(degrees: Double(self) / 60 * 15)
    }
}

protocol ClockEngineInterface {
    func getCurrentHourInMinutes() -> Int
}

class ClockEngine: ClockEngineInterface {
    func getCurrentHourInMinutes() -> Int {
        let calendar = Calendar.current
        let currentTime = Date.now
        let hour = calendar.component(.hour, from: currentTime)
        let minute = calendar.component(.minute, from: currentTime)
        let second = calendar.component(.second, from: currentTime)
        let totalMinutes = (hour * 60 + minute) + second / 60
        return totalMinutes
    }
}

struct RoutineDTO: Identifiable {
    let id: UUID
    let startTime: Date
    let endTime: Date
    let color: Color
    
    init(
        id: UUID = UUID(),
        startTime: Date,
        endTime: Date,
        color: Color
    ) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.color = color
    }
}

extension RoutineDTO {
    var presentable: PresentableRoutine {
        let calendar = Calendar.current
        let startHour = CGFloat(calendar.component(.hour, from: startTime))
        let startMinute = CGFloat(calendar.component(.minute, from: startTime))
        let endHour = CGFloat(calendar.component(.hour, from: endTime))
        let endMinute = CGFloat(calendar.component(.minute, from: endTime))
        
        let start = (startHour + startMinute / 60.0) / 24.0
        let end = (endHour + endMinute / 60.0) / 24.0
        
        return PresentableRoutine(id: id, start: start, end: end, color: color)
    }
}

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
    TabView {
        NavigationStack {
            HomeView()
        }
        Text("sda")
        Text("111")
    }
}
