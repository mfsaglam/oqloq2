//
//  oqloqWidget.swift
//  oqloqWidget
//
//  Created by Fatih Sağlam on 8.12.2024.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let service = RoutineStore.shared.makeSnapshotService()

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), presentableRoutines: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(SimpleEntry(date: Date(), presentableRoutines: loadRoutines()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SimpleEntry(date: Date(), presentableRoutines: loadRoutines())
        completion(Timeline(entries: [entry], policy: .atEnd))
    }
}

extension Provider {
    /// An unreadable store yields no routines rather than a never-completed
    /// timeline request, which previously left the widget on its placeholder.
    private func loadRoutines() -> [PresentableRoutine] {
        do {
            return try service.loadRoutines().map { $0.presentable }
        } catch {
            print("[oqloq widget] Failed to fetch routines from store: \(error)")
            return []
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let presentableRoutines: [PresentableRoutine]
}

struct oqloqWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        WidgetClockView(
            routines: entry.presentableRoutines,
            angle: StaticClockEngine(date: entry.date).currentAngle()
        )
        .padding(4)
    }
}

struct oqloqWidget: Widget {
    let kind: String = "oqloqWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                oqloqWidgetEntryView(entry: entry)
                    .containerBackground(for: .widget) { ThemeStore.load().color }
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
