//
//  OqloqWidgetLiveActivity.swift
//  OqloqWidget
//
//  Created by Saglam, Fatih on 18.08.2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct OqloqWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct OqloqWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: OqloqWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension OqloqWidgetAttributes {
    fileprivate static var preview: OqloqWidgetAttributes {
        OqloqWidgetAttributes(name: "World")
    }
}

extension OqloqWidgetAttributes.ContentState {
    fileprivate static var smiley: OqloqWidgetAttributes.ContentState {
        OqloqWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: OqloqWidgetAttributes.ContentState {
         OqloqWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: OqloqWidgetAttributes.preview) {
   OqloqWidgetLiveActivity()
} contentStates: {
    OqloqWidgetAttributes.ContentState.smiley
    OqloqWidgetAttributes.ContentState.starEyes
}
