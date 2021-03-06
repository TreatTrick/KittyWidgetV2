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
//    let defaultData = BasicData(background: UIImage(named:"img1")!, display: .date, kitty: UIImage(named:"kitty1")!, name: "widget 1")
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), is24Hour: MyData.is24Hour, basicData: MyData.defaultData)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, is24Hour: MyData.is24Hour, basicData: MyData.defaultData)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let selectedWidget = selectWidget(for: configuration)
        let currentDate = Date()
        var entries: [SimpleEntry] = []
        let is24 = UserDefaults(suiteName: UserDataKeys.suiteName)!.bool(forKey: UserDataKeys.is24Hour)

        for secendOffset in 0 ..< 10 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: secendOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, is24Hour: is24, basicData: selectedWidget)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func selectWidget(for configuration: ConfigurationIntent) -> BasicData{
        var data: [BasicData]
        data = MyData.getStoredData()!
        
        if let idString = configuration.widgets?.identifier{
            if let finalData =  data.first(where: { $0.id == idString }){
                return finalData
            }
            print("in let finalData")
            return MyData.defaultData
        }
        print("in let idString")
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


