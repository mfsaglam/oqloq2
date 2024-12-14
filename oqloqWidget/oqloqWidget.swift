//
//  oqloqWidget.swift
//  oqloqWidget
//
//  Created by Fatih Sağlam on 8.12.2024.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct oqloqWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        OqloqView(routines: [.init(start: 0, end: 0.3, color: .red)])
    }
}

struct oqloqWidget: Widget {
    let kind: String = "oqloqWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                oqloqWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                oqloqWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .supportedFamilies([.systemLarge, .systemExtraLarge])
        .description("This is an example widget.")
    }
}

#Preview(as: .systemLarge) {
    oqloqWidget()
} timeline: {
    SimpleEntry(date: .now)
}
