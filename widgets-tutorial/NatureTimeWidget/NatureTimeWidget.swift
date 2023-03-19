//
//  NatureTimeWidget.swift
//  NatureTimeWidget
//
//  Created by Hollins, Cecilia on 2/11/2022.
//

import WidgetKit
import SwiftUI

struct Provider: IntentTimelineProvider {

    typealias Entry = SimpleEntry
    typealias Intent = NatureThemeSelectionIntent
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), theme: .beach)
    }

    func getSnapshot(for configuration: NatureThemeSelectionIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), theme: .beach)
        completion(entry)
    }

    func getTimeline(for configuration: NatureThemeSelectionIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let selectedTheme = theme(for: configuration)
        
        let currentDate = Date()
        let midnight = Calendar.current.startOfDay(for: currentDate)
        let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!

        for offset in 0 ..< 60 * 24 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: offset, to: midnight)!
            entries.append(SimpleEntry(date: entryDate, theme: selectedTheme))
        }

        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
        completion(timeline)
    }
    
    func theme(for configuration: NatureThemeSelectionIntent) -> NatureTheme {
        switch configuration.theme {
        case .beach:
            return .beach
        case .park:
            return .park
        case .city:
            return .city
        default:
            return .beach
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let theme: NatureTheme
}

struct NatureTimeWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            TimeView(theme: entry.theme, imageSize: 175.0, time: entry.date)
        default:
            TimeView(theme: entry.theme, imageSize: 375.0, time: entry.date)
        }
    }
}

@main
struct NatureTimeWidget: Widget {
    let kind: String = "NatureTimeWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: NatureThemeSelectionIntent.self, provider: Provider()) { entry in
            NatureTimeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Nature time")
        .description("Show the time but make it pretty with nature images.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct NatureTimeWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NatureTimeWidgetEntryView(entry: SimpleEntry(date: Date(), theme: .beach))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            NatureTimeWidgetEntryView(entry: SimpleEntry(date: Date(), theme: .beach))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .redacted(reason: .placeholder)
            
            NatureTimeWidgetEntryView(entry: SimpleEntry(date: Date(), theme: .beach))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            NatureTimeWidgetEntryView(entry: SimpleEntry(date: Date(), theme: .beach))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
