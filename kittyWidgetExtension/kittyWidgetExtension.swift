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
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), is24Hour: MyData.is24Hour, storedData: MyData.defaultStore)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        var store: StoredData
        if let id = MyData.getidArray().first{
            if let preData =  UserDefaults(suiteName: UserDataKeys.suiteName)!.data(forKey: id){
                if let data = try? JSONDecoder().decode(StoredData.self, from: preData){
                    store = data
                } else {
                    store = MyData.defaultStore
                }
            } else {
                store = MyData.defaultStore
            }
        } else {
            store = MyData.defaultStore
        }
        let entry = SimpleEntry(date: Date(), configuration: configuration, is24Hour: MyData.is24Hour, storedData: store)
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
            let entry = SimpleEntry(date: currentDate, configuration: configuration, is24Hour: is24, storedData: selectedWidget)
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
                let entry = SimpleEntry(date: currentDate, configuration: configuration, is24Hour: is24, storedData: selectedWidget)
                entries.append(entry)
            } else {
                policy = .atEnd
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY:MM:dd:HH:mm"
                let str = dateFormatter.string(from: currentDate)
                let date0 = dateFormatter.date(from: str)!
                for secendOffset in 0 ..< 15 {
                    let entryDate = Calendar.current.date(byAdding: .minute, value: secendOffset, to: date0)!
                    let entry = SimpleEntry(date: entryDate, configuration: configuration, is24Hour: is24, storedData: selectedWidget)
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
            let entry = SimpleEntry(date: currentDate, configuration: configuration, is24Hour: is24, storedData: selectedWidget)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: policy)
        completion(timeline)
    }
    
    func selectWidget(for configuration: ConfigurationIntent) -> StoredData{
        
        if let idString = configuration.widgets?.identifier{
            if let preData =  UserDefaults(suiteName: UserDataKeys.suiteName)!.data(forKey: idString){
                if let data = try? JSONDecoder().decode(StoredData.self, from: preData){
                    let store = data
                    return store
                } 
            }
        }
        return MyData.defaultStore
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let is24Hour: Bool
    let storedData: StoredData
}

struct kittyWidgetExtensionEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView3(storedData: entry.storedData, isKitty: entry.storedData.isKitty, isWord: entry.storedData.isWord, isBlur: entry.storedData.isBlur, isAllBlur: entry.storedData.isAllBlur, is24Hour: entry.is24Hour, font: entry.storedData.font,date: entry.date)
                .widgetURL(URL(string: entry.storedData.url))

        default :
            MiddleWidgetView2(storedData: entry.storedData, isKitty: entry.storedData.isKitty, isWord: entry.storedData.isWord, isBlur: entry.storedData.isBlur, isAllBlur: entry.storedData.isAllBlur, is24Hour: entry.is24Hour, font: entry.storedData.font, date: entry.date)
                .widgetURL(URL(string: entry.storedData.url))

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


