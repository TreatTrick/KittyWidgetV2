import SwiftUI
import WidgetKit
import EventKit

struct MiddleWidgetView2: View {
    @Environment(\.colorScheme) var colorScheme
    var basicData: BasicData
    var isKitty: Bool
    var isWord: Bool
    var isBlur: Bool
    var isAllBlur: Bool
    var is24Hour: Bool
    var font: FontNames
    var date = Date()
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7)
    let weekdays: [String] = ["日","一","二","三","四","五","六"]
    
    var body: some View {
        ZStack {
            calBackground(isAllBlur: self.isAllBlur)
            HStack{
                if !basicData.isCalendar && isWord && basicData.display == .date{
                    Spacer()
                    VStack{
                        VStack(alignment: .leading){
                            HStack{
                                if is24Hour{
                                    Text(dateSetting(.time, is24Hour: self.is24Hour, date: date))
                                        .font(.custom(font.rawValue, size: 32))
                                        .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)

                                } else {
                                    Text(dateSetting(.time, is24Hour: self.is24Hour, date: date).split(separator: " ").first!)
                                        .font(.custom(font.rawValue, size: 30))
                                        .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)

                                    Text(dateSetting(.time, is24Hour: self.is24Hour, date: date).split(separator: " ").last!)
                                        .font(.custom(font.rawValue, size: 10))
                                        .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                        .offset(x: -4, y: 6)

                                }
//
                            }
//
                            Text(dateSetting(.date, is24Hour: self.is24Hour, date: date))
                                .font(.custom(font.rawValue, size: 12))
                                .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).main)
                        }
                        .background(calBlurBackground(isBlur: self.isBlur))
                        .cornerRadius(10)
                        .offset(y: 6)

                        Text(dateSetting(.week, is24Hour: self.is24Hour, date: date))
                            .font(.custom(font.rawValue, size: 21))
                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).main)
                            .padding(3)
                            .background(calBlurBackground(isBlur: self.isBlur))
                            .cornerRadius(10)
                            .padding(8)
                    }
                }

                if isWord && (basicData.customWord1 != "" ||  basicData.customWord2 != ""  ) && basicData.display == .customize{
                    VStack(alignment: .leading){
                        Spacer()
                        if  basicData.customWord1 != "" {
                            Text(basicData.customWord1)
                                .font(.custom(font.rawValue, size: basicData.midCustomFont1))
                                .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                .padding(4)
                                .background(calBlurBackground(isBlur: self.isBlur))
                                .cornerRadius(10)
                        }

                        if basicData.customWord2 != "" {
                            Text(basicData.customWord2)
                                .font(.custom(font.rawValue, size: basicData.midCustomFont2))
                                .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                .padding(4)
                                .background(calBlurBackground(isBlur: self.isBlur))
                                .cornerRadius(10)
                        }
                    }
                    .padding(12)
                }
                
                if isWord && basicData.isCalendar && basicData.display == .date{
                    Spacer()
                    VStack(alignment: .leading){
                        HStack{
                            Text(returnMonth().split(separator: "/")[1] + "月")
                                .font(.system(size: 15))
                            Spacer()
                            if EKEventStore.authorizationStatus(for: .event) == .authorized{
                                if let events:[EKEvent] = self.getEvents(date: self.date){
                                    if (events.first != nil){
                                    Text(events.first!.title)
                                        .font(.system(size: 15))
                                    } else {
                                        Text("今日无例程")
                                            .font(.system(size: 15))
                                    }
                                }
                            } else {
                                Text("无法访问日历")
                                    .font(.system(size: 15))
                            }
                            
                        }
                        LazyVGrid(columns: columns){
                            ForEach(weekdays, id: \.self){ value in
                                Text(value)
                                    .font(.system(size: 10))
                            }
                            ForEach(dateList(), id:\.self){ value in
                                Text(value.day)
                                    .font(.system(size: 10))
                                    .background(
                                        Group{
                                            if value.day == returnDay(){
                                                Circle().foregroundColor(FuncForSmallWidgets.calAntiColor(fontColor: self.basicData.fontColor)).frame(width: 15, height: 15, alignment: .center)
                                            } else {
                                                EmptyView()
                                            }
                                        }
                                    )
                            }
                        }
                    }
                    .padding(5)
                    .frame(minWidth:170 ,maxWidth: 200)
                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).main)
                    .background(calBlurBackground(isBlur: self.isBlur))
                    .cornerRadius(10)
                }
                
                if isWord && basicData.display == .event{
                    Spacer()
                    VStack{
                        Spacer()
                        HStack(alignment: .center){
                            let date0 = MyData.date2zero(date: self.date)
                            let deltaDay = date0.deltaDay(to: basicData.eventDay)
                            if deltaDay >= 0{
                                Text("离")
                                    .font(.custom(font.rawValue, size: basicData.midEventFont))
                                +
                                Text(basicData.eventName)
                                    .font(.custom(font.rawValue, size: basicData.midEventFont + Coefficients.midEventFontDelta))
                                +
                                Text("还有")
                                    .font(.custom(font.rawValue, size: basicData.midEventFont))
                            } else {
    ////
                                Text(basicData.eventName)
                                    .font(.custom(font.rawValue, size: basicData.midEventFont + Coefficients.midEventFontDelta))
                                +
                                Text("已经")
                                    .font(.custom(font.rawValue, size: basicData.midEventFont))
                            }

                        }
                        .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                        .padding(4)
                        .background(calBlurBackground(isBlur: self.isBlur))
                        .cornerRadius(10)

                        HStack(alignment: .center){
                            let date0 = MyData.date2zero(date: self.date)
                            let deltaDay = date0.deltaDay(to: basicData.eventDay)
                            Text(String(abs(deltaDay)))
                                .font(.custom(font.rawValue, size: basicData.midEventFont + Coefficients.midEventFontDelta))
                            +
                            Text("天")
                                .font(.custom(font.rawValue, size: basicData.midEventFont))
                        }
                        .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                        .padding(4)
                        .background(calBlurBackground(isBlur: self.isBlur))
                        .cornerRadius(10)
                        
                        Spacer()
                        
                        HStack{
                            let date0 = MyData.date2zero(date: self.date)
                            let deltaDay = date0.deltaDay(to: basicData.eventDay)
                            if deltaDay >= 0{
                                Text("目标日: \(returnFullDate())")
                                    .font(.custom(font.rawValue, size: 8))
                                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                    .padding(3)
                                    .background(calBlurBackground(isBlur: self.isBlur))
                                    .cornerRadius(10)
                            } else {
                                Text("始于: \(returnFullDate())")
                                    .font(.custom(font.rawValue, size: 8))
                                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                    .padding(3)
                                    .background(calBlurBackground(isBlur: self.isBlur))
                                    .cornerRadius(10)
                            }
                            Spacer()
                        }
                        .padding(4)
                    }
                }
                    
                Spacer()
                
                if isKitty{
                    ZStack{
                        Image(uiImage: basicData.kitty)
                            .resizable()
                            .scaledToFit()
                            .clipped()
                    }
                }
                
                if !isKitty && isWord && basicData.isCalendar && basicData.display == .date{
                    VStack(alignment: .leading){
                        if EKEventStore.authorizationStatus(for: .event) == .authorized{
                            Text("今日：")
                            if let events = self.getEvents(date: self.date){
                                if (events.first != nil){
                                    ForEach(events, id:\.eventIdentifier){ event in
                                        Text(event.title)
                                    }
                                } else {
                                    Text("今日无例程")
                                }
                            }
                            Spacer()

                            Text("明日：")
                            if let events2 = self.getEvents(date: Calendar.current.date(byAdding: .day, value: 1, to: self.date)!){
                                if (events2.first != nil){
                                    ForEach(events2, id:\.eventIdentifier ){ event in
                                        Text(event.title)
                                    }
                                } else {
                                    Text("明日无例程")
                                }
                            }
                        } else {
                            Text("无法访问日历")
                        }
                    }
                    .font(.custom(font.rawValue, size: 10))
                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                    .padding(4)
                    .background(calBlurBackground(isBlur: self.isBlur))
                    .cornerRadius(10)
                    .frame(maxHeight:100)

                    Spacer()
                }

            }
        }
        .environment(\.sizeCategory, .extraExtraExtraLarge)
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
    
    func returnDay() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_Hans_CN")
        dateFormatter.dateStyle = .short
        let str = dateFormatter.string(from: self.date)
        return String(str.split(separator: "/").last!)
    }
    
    func returnFullDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_Hans_CN")
        dateFormatter.dateStyle = .full
        let str = dateFormatter.string(from: self.basicData.eventDay)
        return str
    }
    
    func returnMonth() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_Hans_CN")
        dateFormatter.dateStyle = .short
        let str = dateFormatter.string(from: self.date)
        return str
    }
    
    func dateList() -> [myCalendar]{
        let range = Calendar.current.range(of: .day, in: .month, for: self.date)!
        let ymd = self.returnMonth()
        let dayvalue = Int(ymd.split(separator: "/").last!)! - 1
        let firstDay = Calendar.current.date(byAdding: .day, value: -dayvalue, to: self.date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_Hans_CN")
        dateFormatter.dateStyle = .full
        let str = dateFormatter.string(from: firstDay!)
        var firstDayValue: Int
        
        switch str.split(separator: " ").last!{
        case "星期一": firstDayValue = 2
        case "星期二": firstDayValue = 3
        case "星期三": firstDayValue = 4
        case "星期四": firstDayValue = 5
        case "星期五": firstDayValue = 6
        case "星期六": firstDayValue = 7
        default: firstDayValue = 1
        }
        
        var dateList: [myCalendar] = []
        for _ in 0..<firstDayValue-1{
            dateList.append(myCalendar(day: " "))
        }
        for i in 1...range.count{
            dateList.append(myCalendar(day: String(i)))
        }
        return dateList
    }
    
    func dateSetting(_ timeOrDate: tdSelection, is24Hour: Bool, date: Date) -> String{
        var displayString: String
        let dateFormatter = DateFormatter()
        print(date)
        switch timeOrDate{
        case .date:
            dateFormatter.dateFormat = "MM:dd"
            let dateString = dateFormatter.string(from: date) // 2001/01/02
            let ymd = dateString.split(separator: ":")
            displayString = ymd[0] + "月" + ymd[1] + "日"
        case .time:
            if is24Hour{
                dateFormatter.dateFormat = "HH:mm"
                let dateString = dateFormatter.string(from: date) // 2001/01/02
                let ymd = dateString.split(separator: ":")
                displayString = ymd[0] + ":" + ymd[1]
            } else {
//                dateFormatter.dateFormat = "h:mm:a"
                dateFormatter.dateFormat = "HH:mm"
                let dateString = dateFormatter.string(from: date).split(separator:":")
                var ap = ""
                if Int(dateString.first!)! >= 12 {
                    ap = "PM"
                } else {
                    ap = "AM"
                }
                var hour: Int
                if (Int(dateString.first!)! == 12) || (Int(dateString.first!)! == 0){
                     hour = 12
                } else {
                     hour = Int(dateString.first!)! % 12
                }
                displayString = String(hour) + ":" + dateString.last! + " " + ap
            }
        case .week:
            let weekid = Calendar.current.component(.weekday, from: date)
            var weekday: String
            switch weekid{
            case 1: weekday = "周日"
            case 2: weekday = "周一"
            case 3: weekday = "周二"
            case 4: weekday = "周三"
            case 5: weekday = "周四"
            case 6: weekday = "周五"
            default: weekday = "周六"
            }
            displayString = weekday
            
            
        }
        return displayString
    }
    
    
    enum tdSelection{
        case time
        case date
        case week
    }
    
    func calBlurBackground(isBlur: Bool) -> some View{
        GeometryReader{ geometry in
            if isBlur{
                ZStack{
                    Image(uiImage:self.basicData.blurBackground).resizable().scaledToFill().frame(width: geometry.size.width, height: geometry.size.height).clipped()
                    Color(self.colorScheme == .light ? .white : .black).opacity(self.colorScheme == .light ? 0.3 : 0.25)
                }
            } else {
                EmptyView()
            }
        }
    }
    
    func calBackground(isAllBlur: Bool) -> some View{
        GeometryReader{ geometry in
            if isAllBlur{
                ZStack {
                    Image(uiImage: self.basicData.blurBackground).resizable().scaledToFill().frame(width: geometry.size.width, height: geometry.size.height).clipped()
                    Color(self.colorScheme == .light ? .white : .black).opacity(0.2)
                }
            } else {
                Image(uiImage: self.basicData.background).resizable().scaledToFill().frame(width: geometry.size.width, height: geometry.size.height).clipped()
            }
        }
    }
    
    
}


