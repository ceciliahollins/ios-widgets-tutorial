//
//  NatureTimeWidget.swift
//  NatureTimeWidget
//
//  Created by Hollins, Cecilia on 2/11/2022.
//

import WidgetKit
import SwiftUI

/// The Provider tells WidgetKit when to update the widget's content
///
/// There are two options for the provider. Conforming to the IntentTimelineProvider protocol allows for user configurable actions, while the TimelineProvider does not. If your widget does not need user configurations to display, then conform to TimelineProvider instead.
struct Provider: IntentTimelineProvider {

    /// Creates the entry data for the widget to consume at a specific moment
    typealias Entry = NatureTimeEntry
    
    /// The configurable settings of the widget
    ///
    /// Define configurations through a custom SiriKit Intent Defintion file. For this project, the configuration is the type of nature setting the user would like to display as the background of the widget.
    typealias Intent = NatureThemeSelectionIntent
    
    /// A view to render placeholder UI while waiting for the widget data to load
    func placeholder(in context: Context) -> NatureTimeEntry {
        NatureTimeEntry(date: Date(), theme: .beach)
    }

    /// Provides the view for transient situations
    ///
    /// An example of a transient situation is previewing the widget in the widget gallery before selecting the widget. It should be quick to load and may show dummy data as to not keep the user waiting.
    func getSnapshot(for configuration: NatureThemeSelectionIntent, in context: Context, completion: @escaping (NatureTimeEntry) -> ()) {
        let entry = NatureTimeEntry(date: Date(), theme: .beach)
        completion(entry)
    }

    /// Provides the timeline entries for the current time and state of a widget
    ///
    /// This is the main logic for updating the widgets data overtime. If the widget is showing static UI, This function can return just 1 timeline entry. Otherwise, append the entries into an array based on how many and the data that will be passed to return.
    func getTimeline(for configuration: NatureThemeSelectionIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [NatureTimeEntry] = []
        
        let selectedTheme = theme(for: configuration)
        
        let currentDate = Date()
        let midnight = Calendar.current.startOfDay(for: currentDate)
        let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!

        for offset in 0 ..< 60 * 24 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: offset, to: midnight)!
            entries.append(NatureTimeEntry(date: entryDate, theme: selectedTheme))
        }

        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
        completion(timeline)
    }
    
    /// A helper function not required by the protocol
    ///
    /// Converts the configuration intent into the project defined theme.
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

/// The model for the widget, requiring the date for when that data will be displayed and optionally any other data required
///
/// The date will be used to inform the system that is has new data to show and the widget needs to be refreshed at that time. Other data we may need will also be held here.
struct NatureTimeEntry: TimelineEntry {
    let date: Date
    let theme: NatureTheme
}

/// The view for the widget, build using SwiftUI
///
/// The view is build the same way a normal SwiftUI view would be built. Because widget family options will be of different shapes and sizes, the view may need to be customized. Do this by adding an environment variable for the widgetFamily and a switch case for this variable.
///
/// The entry parameter is used to provide the needed data for the view. The entry is of type Provider.Entry, which points to the TimelineEntry struct created as our model for the widget.
struct NatureTimeWidgetEntryView: View {
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

/// The main configuration, where everything is brought together to create the widget
///
/// This is where the timeline provider gets hooked up with the widget view. There are two types of configurations, StaticConfiguration and IntentConfiguration. IntentConfiguration allows for user configuration options, while StaticConfiguration does not. If user customization is allowed on the widget, use IntentConfiguration.
///
/// The kind parameter should provide a unique string to identify the widget when loading its timeline into the widget center.
///
/// The intent parameter provides the user configurable options, created using SiriKit custom intents.
///
/// The provider parameter is the widgets IntentTimelineProvider or TimelineProvider, used to create the timeline for when the widget will be refreshed.
///
/// Modifiers on the configuration should include a minimum of the configuration display name, the description, and the supported families. The configuration display name and description are used in the widget gallery, and the supported families tells the system which sizes the widget supports.
@main
struct NatureTimeWidget: Widget {
    let kind: String = "widgets-tutorial-nature-time"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: NatureThemeSelectionIntent.self,
                            provider: Provider()) { entry in
            NatureTimeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Nature time")
        .description("Show the time but make it pretty with nature images.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

/// Preview the widgets families and placeholder views
///
/// Use the previewContext modifier to pass in and view a specific family type
///
/// Use the redacted modifier to view placeholder UI
struct NatureTimeWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NatureTimeWidgetEntryView(entry: NatureTimeEntry(date: Date(), theme: .beach))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            NatureTimeWidgetEntryView(entry: NatureTimeEntry(date: Date(), theme: .beach))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .redacted(reason: .placeholder)
            
            NatureTimeWidgetEntryView(entry: NatureTimeEntry(date: Date(), theme: .beach))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            NatureTimeWidgetEntryView(entry: NatureTimeEntry(date: Date(), theme: .beach))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
