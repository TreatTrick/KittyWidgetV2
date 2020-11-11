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
    let dateFormatter = DateFormatter()
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), is24Hour: MyData.is24Hour, basicData: MyData.defaultData)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        var basicData: BasicData
        if let id = MyData.getidArray().first{
            basicData = MyData.store2basic(id: id) ?? MyData.defaultData
        } else {
            basicData = MyData.defaultData
        }
        let entry = SimpleEntry(date: Date(), configuration: configuration, is24Hour: MyData.is24Hour, basicData: basicData)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let selectedWidget = selectWidget(for: configuration)
        let currentDate = Date()
        var entries: [SimpleEntry] = []
        let is24 = UserDefaults(suiteName: UserDataKeys.suiteName)!.bool(forKey: UserDataKeys.is24Hour)
        var policy: TimelineReloadPolicy
        
        switch selectedWidget.display{
        case .customize:
            policy = .never
            let entry = SimpleEntry(date: currentDate, configuration: configuration, is24Hour: is24, basicData: selectedWidget)
            entries.append(entry)
        case .date:
            if selectedWidget.isCalendar{
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "zh_Hans_CN")
                dateFormatter.dateStyle = .short
                let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
                let str = dateFormatter.string(from: nextDay!)
                let dateFormatter2 = DateFormatter()
                dateFormatter2.dateFormat = "YYYY/MM/dd"
                let reloadDay = dateFormatter2.date(from: str)!
                policy = .after(reloadDay)
                let entry = SimpleEntry(date: currentDate, configuration: configuration, is24Hour: is24, basicData: selectedWidget)
                entries.append(entry)
            } else {
                policy = .atEnd
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY:MM:dd:HH:mm"
                let str = dateFormatter.string(from: currentDate)
                let date0 = dateFormatter.date(from: str)!
                for secendOffset in 0 ..< 15 {
                    let entryDate = Calendar.current.date(byAdding: .minute, value: secendOffset, to: date0)!
                    let entry = SimpleEntry(date: entryDate, configuration: configuration, is24Hour: is24, basicData: selectedWidget)
                    entries.append(entry)
                }
            }
        case .event:
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "zh_Hans_CN")
            dateFormatter.dateStyle = .short
            let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
            let str = dateFormatter.string(from: nextDay!)
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "YYYY/MM/dd"
            let reloadDay = dateFormatter2.date(from: str)!
            policy = .after(reloadDay)
            let entry = SimpleEntry(date: currentDate, configuration: configuration, is24Hour: is24, basicData: selectedWidget)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: policy)
        completion(timeline)
    }
    
    func selectWidget(for configuration: ConfigurationIntent) -> BasicData{
        if let idString = configuration.widgets?.identifier{
            let basicData = MyData.store2basic(id: idString) ?? MyData.defaultData
            return basicData
        }
        return MyData.defaultData
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let is24Hour: Bool
    let basicData: BasicData
}

struct kittyWidgetExtensionEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView3(basicData: entry.basicData, isKitty: entry.basicData.isKitty, isWord: entry.basicData.isWord, isBlur: entry.basicData.isBlur, isAllBlur: entry.basicData.isAllBlur, is24Hour: entry.is24Hour, font: entry.basicData.font,date: entry.date)
                .widgetURL(URL(string: entry.basicData.url))

        default :
            MiddleWidgetView2(basicData: entry.basicData, isKitty: entry.basicData.isKitty, isWord: entry.basicData.isWord, isBlur: entry.basicData.isBlur, isAllBlur: entry.basicData.isAllBlur, is24Hour: entry.is24Hour, font: entry.basicData.font, date: entry.date)
                .widgetURL(URL(string: entry.basicData.url))

        }
    }
}

@main
struct kittyWidgetExtension: Widget {
    let kind: String = "kittyWidgetExtension"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            kittyWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("PicWidgets")
        .description("请选择想要添加到屏幕的小组件")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}


