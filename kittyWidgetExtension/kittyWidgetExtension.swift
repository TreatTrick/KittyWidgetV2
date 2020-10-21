//
//  kittyWidgetExtension.swift
//  kittyWidgetExtension
//
//  Created by SORA on 2020/9/26.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    @EnvironmentObject var myData: MyData
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), basicData: BasicData(background: UIImage(named:"img1")!, display: .date, kitty: UIImage(named:"kitty1")!, name: "widget 1"))
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, basicData: BasicData(background: UIImage(named:"img1")!, display: .date, kitty: UIImage(named:"kitty1")!, name: "widget 1"))
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let selectedWidget = selectWidget(for: configuration)
        let currentDate = Date()
        var entries: [SimpleEntry] = []
        let oneMinute: TimeInterval = 60
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, basicData: selectedWidget)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func selectWidget(for configuration: ConfigurationIntent) -> BasicData{
        if let idString = configuration.parameter?.identifier{
            let id = UUID(uuidString: idString)!
            return self.myData.dataStream.first(where: { $0.id == id })!
        }
        
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let basicData: BasicData
}

struct kittyWidgetExtensionEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text("23333")
        SmallWidgetView2(basicData: entry.basicData, isKitty: entry.basicData.isKitty, isWord: entry.basicData.isWord, isBlur: entry.basicData.isBlur, isAllBlur: entry.basicData.isAllBlur, is24Hour: true, font: entry.basicData.font)
            .widgetURL(URL(string: "OpenedApp://")!)
    }
}

@main
struct kittyWidgetExtension: Widget {
    let kind: String = "kittyWidgetExtension"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            kittyWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

//struct kittyWidgetExtension_Previews: PreviewProvider {
//    static var previews: some View {
//        kittyWidgetExtensionEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), basicData: <#BasicData#>))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
