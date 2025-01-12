//
//  oqloqWidget.swift
//  oqloqWidget
//
//  Created by Fatih Sağlam on 8.12.2024.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let service = RealmRoutineService()

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), presentableRoutines: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        do {
            let presentableRoutines = try service.loadRoutines().map { $0.presentable }
            let entry = SimpleEntry(date: Date(), presentableRoutines: presentableRoutines)
            completion(entry)
        } catch {
            print("Failed to fetch routines from store.")
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        do {
            let presentableRoutines = try service.loadRoutines().map { $0.presentable }
            let entry = SimpleEntry(date: Date(), presentableRoutines: presentableRoutines)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        } catch {
            print("Failed to fetch routines from store.")
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let presentableRoutines: [PresentableRoutine]
}

struct oqloqWidgetEntryView : View {
    var entry: Provider.Entry
    
    @StateObject var vm = OqloqViewModel(
        engine: ClockEngine()
    )

    var body: some View {
        ZStack {
            // routines
            Circle()
                .stroke(lineWidth: 3)
                .foregroundStyle(
                    .solidBack.opacity(0.8)
                )
                .blur(radius: 1)
                .frame(height: 310)
            
            ForEach(entry.presentableRoutines) { routine in
                RoutineView(routine: routine)
            }
            
            // oqloq
            ZStack {
                // solid clock
                Circle()
                    .fill(.solidBack)
                    .frame(height: 260)
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
                    .frame(height: 260)
                    .rotationEffect(.degrees(-30))
                    .padding(.vertical)
                
                // indicator
                Circle()
                    .trim(from: 0.0, to: 0.002)
                    .stroke(.primary, lineWidth: 40)
                    .frame(height: 220)
                    .rotationEffect(Angle(degrees: -90))
                    .rotationEffect(vm.angle)
            }
        }
        .shadow(color: .black.opacity(0.3), radius: 30, x: 30, y: 30)
    }
}

struct oqloqWidget: Widget {
    let kind: String = "oqloqWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                oqloqWidgetEntryView(entry: entry)
                    .containerBackground(for: .widget) { Color.wallpaper }
            } else {
                oqloqWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("oqloq Widget")
        .supportedFamilies([.systemLarge, .systemExtraLarge])
        .description("Track your routines.")
    }
}

#Preview(as: .systemLarge) {
    oqloqWidget()
} timeline: {
    SimpleEntry(date: .now, presentableRoutines: [.init(start: 0.1, end: 0.6, color: .green)])
}
