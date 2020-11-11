//
//  test.swift
//  KittyWidgetV2
//
//  Created by SORA on 2020/10/15.
//

import SwiftUI
import WidgetKit
import EventKit

struct SmallWidgetView2: View {
    @Environment(\.colorScheme)  var colorScheme
    var basicData: BasicData
    var isKitty: Bool
    var isWord: Bool
    var isBlur: Bool
    var isAllBlur: Bool
    var is24Hour: Bool
    var font: FontNames
    var date = Date()
    
    var body: some View {
        ZStack{
            calBackground(isAllBlur: self.isAllBlur, basicData: self.basicData)
            VStack(alignment:.center){
                Group{
                    if isWord && basicData.display == .date{
                        VStack(alignment: .leading){
                            HStack{
                                if !basicData.isCalendar{
                                    if is24Hour{
                                        Time(dateSetting: .time,a: false, is24Hour: is24Hour)
                                            .font(.custom(font.rawValue, size: 25))
                                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                    } else {
                                        Time(dateSetting: .time,a: false, is24Hour: is24Hour)
                                            .font(.custom(font.rawValue, size: 25))
                                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                        Time(dateSetting: .time, a: true, is24Hour: is24Hour)
                                            .font(.custom(font.rawValue, size: Coefficients.apSize))
                                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                            .offset(x: -4, y: 5)
                                    }
                                } else {
                                    if EKEventStore.authorizationStatus(for: .event) == .authorized{
                                        if let events:[EKEvent] = self.getEvents(date: self.date){
                                            if (events.first != nil){
                                            Text(events.first!.title)
                                                .font(.custom(font.rawValue, size: 15))
                                                .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                            } else {
                                                Text("今日无例程")
                                                    .font(.custom(font.rawValue, size: 12))
                                                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                            }
                                        }
                                    } else {
                                        Text("无法访问日历")
                                            .font(.custom(font.rawValue, size: 12))
                                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                    }
                                }
                            }
                            
                            if !basicData.isCalendar{
                                Time(dateSetting: .date, a: false, is24Hour: is24Hour)
                                    .font(.custom(font.rawValue, size: 10))
                                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).main)
                            } else {
                                Text(returnMonth().split(separator: "/")[1] + "月" + returnMonth().split(separator: "/")[2] + "日")
                                    .font(.custom(font.rawValue, size: 10))
                                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).main)
                            }
                            
                        }
                        .padding(4)
                        .background(calBlurBackground(isBlur: self.isBlur, basicData: self.basicData))

                        .cornerRadius(10)
                        .offset(y: 6)
                        
                    }
                    
                    if isWord && basicData.customWord1 != "" && isKitty && basicData.display == .customize{
                        Text(basicData.customWord1)
                            .font(.custom(font.rawValue, size: basicData.customFont1))
                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                            .padding(4)
                            .background(calBlurBackground(isBlur: self.isBlur, basicData: self.basicData))
                            .cornerRadius(10)
                            .offset(y: 6)
                    }
                    
                    if isWord && basicData.display == .event{
                        HStack(alignment: .center){
                            let date0 = MyData.date2zero(date: self.date)
                            let deltaDay = date0.deltaDay(to: basicData.eventDay)
                            if deltaDay >= 0{
                                Text("离")
                                    .font(.custom(font.rawValue, size: basicData.eventFont))
                                +
                                Text(basicData.eventName)
                                    .font(.custom(font.rawValue, size: basicData.eventFont + Coefficients.eventFontDelta))
                                +
                                Text("还有")
                                    .font(.custom(font.rawValue, size: basicData.eventFont))
                            } else {
                                
                                Text(basicData.eventName)
                                    .font(.custom(font.rawValue, size: basicData.eventFont + Coefficients.eventFontDelta))
                                +
                                Text("已经")
                                    .font(.custom(font.rawValue, size: basicData.eventFont))
                            }
                                
                        }
                        .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                        .padding(4)
                        .background(calBlurBackground(isBlur: self.isBlur, basicData: self.basicData))
                        .cornerRadius(10)
                        .offset(y: 6)

                    }
                }
                .padding(3)
                
                if isKitty{
                    Spacer()
                }
                
                HStack{
                    if isWord && basicData.display == .date{
                        Spacer()
                        Time(dateSetting: .week, a: false, is24Hour: is24Hour)
                            .font(.custom(font.rawValue, size: 19))
                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).main)
                            .padding(3)
                            .background(calBlurBackground(isBlur: self.isBlur, basicData: self.basicData))

                            .cornerRadius(10)
                            .padding(3)
                        Spacer()
                    }
                    
                    if isWord && basicData.customWord2 != "" && isKitty && basicData.display == .customize{
                        Spacer()
                        Text(basicData.customWord2)
                            .font(.custom(font.rawValue, size: basicData.customFont2))
                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                            .padding(3)
                            .background(calBlurBackground(isBlur: self.isBlur, basicData: self.basicData))

                            .cornerRadius(10)
                            .offset(y: 5)
                        Spacer()
                    }
                    
                    if isWord && basicData.display == .event{
                        Spacer()
                        HStack(alignment: .center){
                            let date0 = MyData.date2zero(date: self.date)
                            let deltaDay = date0.deltaDay(to: basicData.eventDay)
                            Text(String(abs(deltaDay)))
                                .font(.custom(font.rawValue, size: basicData.eventFont + Coefficients.eventFontDelta))
                            +
                            Text("天")
                                .font(.custom(font.rawValue, size: basicData.eventFont))
                        }
                        .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                        .padding(4)
                        .background(calBlurBackground(isBlur: self.isBlur, basicData: self.basicData))

                        .cornerRadius(10)
                        Spacer()
                    }
                    
                    if isKitty{
                        Spacer()
                        ZStack{
                            Image(uiImage: basicData.kitty)
                                .resizable()
                                .scaledToFit()
                                .clipped()
                        }
                    }
                    
                }
                
            }
            
            if isWord && (basicData.customWord2 != "" || basicData.customWord1 != "") && !isKitty && basicData.display == .customize{
                HStack{
                    VStack(alignment: .leading){
                        Spacer()
                        if basicData.customWord1 != ""{
                            Text(basicData.customWord1)
                                .font(.custom(font.rawValue, size: basicData.customFont1))
                                .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                .padding(3)
                                .background(calBlurBackground(isBlur: self.isBlur, basicData: self.basicData))
                                .cornerRadius(10)
                        }
                        
                        if basicData.customWord2 != ""{
                            Text(basicData.customWord2)
                                .font(.custom(font.rawValue, size: basicData.customFont2))
                                .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                .padding(3)
                                .background(calBlurBackground(isBlur: self.isBlur, basicData: self.basicData))
                                .cornerRadius(10)
                        }
                    }
                    Spacer()
                }
                .padding(10)
                
            }
        }
        .frame(width: 150, height: 150)
        .environment(\.sizeCategory, .extraExtraExtraLarge)
        .cornerRadius(CGFloat(Coefficients.cornerRadius))
        .animation(.easeInOut)
    }
    
    func getEvents(date: Date) -> [EKEvent]?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        let str = dateFormatter.string(from: date)
        let oldDay = dateFormatter.date(from: str)!
        let newDay = Calendar.current.date(byAdding: .day,value: 1, to: oldDay)!
        let store = EKEventStore()
        var predicate: NSPredicate? = nil
        var events: [EKEvent]? = nil
        
        predicate = store.predicateForEvents(withStart: oldDay, end: newDay, calendars: nil)
        if let aPredicate = predicate {
            events = store.events(matching: aPredicate)
        }
        return events
    }
    
    func returnMonth() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_Hans_CN")
        dateFormatter.dateStyle = .short
        let str = dateFormatter.string(from: self.date)
        return str
    }
    
    func calBlurBackground(isBlur: Bool, basicData: BasicData) -> some View{
        GeometryReader{ geometry in
            if isBlur{
                ZStack{
                    Image(uiImage: self.basicData.blurBackground).resizable().scaledToFill().frame(width: geometry.size.width, height: geometry.size.height).clipped()
                    Color(self.colorScheme == .light ? .white : .black).opacity(self.colorScheme == .light ? 0.4 : 0.25)
                }
            } else {
                EmptyView()
            }
        }
    }
    
    func calBackground(isAllBlur: Bool, basicData: BasicData) -> some View{
        GeometryReader{ geometry in
            if isAllBlur{
                ZStack {
                    Image(uiImage: basicData.blurBackground).resizable().scaledToFill().frame(width: geometry.size.width, height: geometry.size.height).clipped()
                    Color(self.colorScheme == .light ? .white : .black).opacity(0.2)
                }
            } else {
                Image(uiImage: basicData.background).resizable().scaledToFill().frame(width: geometry.size.width, height: geometry.size.height).clipped()
            }
        }
        
    }
}


struct SmallWidgetView2_Previews: PreviewProvider {
    static var previews: some View {
        SmallWidgetView2(basicData: BasicData(id: UUID().uuidString, background: UIImage(named: "img8")!, display: .date, kitty: UIImage(named: "kitty1")!, name: "widget 1"), isKitty: true, isWord: true, isBlur: true, isAllBlur: false, is24Hour: false, font: .font4)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

