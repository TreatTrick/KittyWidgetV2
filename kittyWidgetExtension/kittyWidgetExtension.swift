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
        //let oneMinute: TimeInterval = 60
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        
        for secendOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .second, value: secendOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, is24Hour: MyData.is24Hour, basicData: selectedWidget)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func selectWidget(for configuration: ConfigurationIntent) -> BasicData{
        if let idString = configuration.widget?.identifier{
            let id = idString
           return MyData.staticDataStream.first(where: { $0.id == id })!
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
    var entry: Provider.Entry
    let id = MyData.idName[2].id
    let data =  MyData.staticDataStream.first(where: { $0.id ==  MyData.idName[2].id })
    let basicData = BasicData(background: UIImage(named:"img1")!, display: .date, kitty: UIImage(named:"kitty1")!, name: "widget 1")

    var body: some View {
//        SmallWidgetView2(basicData: entry.basicData, isKitty: entry.basicData.isKitty, isWord: entry.basicData.isWord, isBlur: entry.basicData.isBlur, isAllBlur: entry.basicData.isAllBlur, is24Hour: entry.is24Hour, font: entry.basicData.font)
//            .widgetURL(URL(string: entry.basicData.url)!)
        
//        SmallWidgetView2(basicData: basicData, isKitty: basicData.isKitty, isWord: basicData.isWord, isBlur: basicData.isBlur, isAllBlur: basicData.isAllBlur, is24Hour: true, font: basicData.font)
//            .widgetURL(URL(string: MyData.defaultData.url)!)
//        Text(MyData.defaultData.name)
        
//        Text("start")
//        if data != nil {
//            Text(data!.name)
//        }
        VStack{
            Text("start")
        //    Image(uiImage: basicData.kitty).resizable().frame(width: 50, height: 50, alignment: .center)
            Image(uiImage: MyData.staticDataStream[2].kitty)
            Text(id)
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
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}


