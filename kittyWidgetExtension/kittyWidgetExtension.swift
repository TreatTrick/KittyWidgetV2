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
//    let defaultData = BasicData(background: UIImage(named:"img1")!, display: .date, kitty: UIImage(named:"kitty1")!, name: "widget 1")
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), is24Hour: MyData.is24Hour, basicData: MyData.defaultData, id: MyData.defaultData.id)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, is24Hour: MyData.is24Hour, basicData: MyData.defaultData, id: MyData.defaultData.id)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let selectedWidget = selectWidget(for: configuration)
        let currentDate = Date()
        var entries: [SimpleEntry] = []


        for secendOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: secendOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, is24Hour: MyData.is24Hour, basicData: selectedWidget, id: configuration.widgets?.identifier ?? "NO ID")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func selectWidget(for configuration: ConfigurationIntent) -> BasicData{
        MyData.staticDataStream = MyData.getStoredData()!
        if let idString = configuration.widgets?.identifier{
            if let finalData =  MyData.staticDataStream.first(where: { $0.id == idString }){
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
    let id: String
}

struct kittyWidgetExtensionEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        SmallWidgetView3(basicData: entry.basicData, isKitty: entry.basicData.isKitty, isWord: entry.basicData.isWord, isBlur: entry.basicData.isBlur, isAllBlur: entry.basicData.isAllBlur, is24Hour: entry.is24Hour, font: entry.basicData.font)
        
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


