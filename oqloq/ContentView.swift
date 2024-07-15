//
//  ContentView.swift
//  oqloq
//
//  Created by Saglam, Fatih on 15.07.2024.
//

import SwiftUI

struct ContentView: View {
    
    let data = ["1", "2", "3"]
    var body: some View {
        NavigationStack {
            ZStack {
                Color.yellow
                    .ignoresSafeArea()
                
                VStack {
                    
                    OqloqView()
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

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .foregroundStyle(
                    .white
                )
                .blur(radius: 1)
                .frame(height: UIScreen.main.bounds.width * 0.9)
                .blendMode(.colorDodge)
            

            Circle()
                .stroke(lineWidth: 8)
                .foregroundStyle(
                    .red
                )
                .frame(height: UIScreen.main.bounds.width * 0.9)
                .mask(alignment: .center) {
                    Circle()
                        .stroke(lineWidth: 5)
                        .foregroundStyle(.white)
                        .blur(radius: 0.9)
                        .offset(x: 2.5)
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
                .frame(height: UIScreen.main.bounds.width * 0.68)
                .rotationEffect(Angle(degrees: -90))
                .rotationEffect(vm.angle)

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
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
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
    func startRunning() -> Int
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
    
    func startRunning() -> Int {
        var updatedMinute: Int = 0
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            updatedMinute += 10
        }
        return updatedMinute
    }
}

#Preview {
    TabView {
        NavigationStack {
            ContentView()
        }
        Text("sda")
        Text("111")
    }
}
