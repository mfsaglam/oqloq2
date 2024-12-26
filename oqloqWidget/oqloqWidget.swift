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
    
    @StateObject var vm = OqloqViewModel(
        engine: ClockEngine()
    )

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 3)
                .foregroundStyle(
                    .solidBack.opacity(0.8)
                )
                .blur(radius: 1)
                .frame(height: 300)
            
            ZStack {
                Circle()
                    .fill(.solidBack)
                    .frame(height: 270)
                    .rotationEffect(.degrees(-30))
                    .padding(.vertical)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.5), .black.opacity(0.2)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .blendMode(.multiply)
                    .frame(height: 270)
                    .rotationEffect(.degrees(-30))
                    .padding(.vertical)
                
                Circle()
                    .trim(from: 0.0, to: 0.002)
                    .stroke(.primary, lineWidth: 40)
                    .frame(height: 230)
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
