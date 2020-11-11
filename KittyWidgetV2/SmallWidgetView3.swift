import SwiftUI
import WidgetKit
import EventKit

struct SmallWidgetView3: View {
    @Environment(\.colorScheme) var colorScheme
    var storedData: StoredData
    var isKitty: Bool
    var isWord: Bool
    var isBlur: Bool
    var isAllBlur: Bool
    var is24Hour: Bool
    var font: FontNames
    var date = Date()
    
    var body: some View {
        ZStack {
            calBackground(isAllBlur: self.isAllBlur)
            VStack(alignment:.center){
                Group{
                    if isWord && storedData.display == .date{
                        VStack(alignment: .leading){
                            HStack{
                                if !storedData.isCalendar{
                                    if is24Hour{
                                        Text(dateSetting(.time, is24Hour: self.is24Hour, date: date))
                                            .font(.custom(font.rawValue, size: 25))
                                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.storedData.fontColor).light)
                                        
                                    } else {
                                        Text(dateSetting(.time, is24Hour: self.is24Hour, date: date).split(separator: " ").first!)
                                            .font(.custom(font.rawValue, size: 25))
                                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.storedData.fontColor).light)
                                        
                                        Text(dateSetting(.time, is24Hour: self.is24Hour, date: date).split(separator: " ").last!)
                                            .font(.custom(font.rawValue, size: Coefficients.apSize))
                                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.storedData.fontColor).light)
                                            .offset(x: -4, y: 5)
                                    }
                                    
                                } else {
                                    if EKEventStore.authorizationStatus(for: .event) == .authorized{
                                        if let events:[EKEvent] = self.getEvents(date: self.date){
                                            if (events.first != nil){
                                                Text(events.first!.title)
                                                    .font(.custom(font.rawValue, size: 15))
                                                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.storedData.fontColor).light)
                                            } else {
                                                Text("今日无例程")
                                                    .font(.custom(font.rawValue, size: 12))
                                                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.storedData.fontColor).light)
                                            }
                                        }
                                    } else {
                                        Text("无法访问日历")
                                            .font(.custom(font.rawValue, size: 12))
                                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.storedData.fontColor).light)
                                    }
                                }
                            }
                            
                            if !storedData.isCalendar{
                                Text(dateSetting(.date, is24Hour: self.is24Hour, date: date))
                                    .font(.custom(font.rawValue, size: 10))
                                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.storedData.fontColor).main)
                            } else {
                                Text(returnMonth().split(separator: "/")[1] + "月" + returnMonth().split(separator: "/")[2] + "日")
                                    .font(.custom(font.rawValue, size: 10))
                                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.storedData.fontColor).main)
                            }
                        }
                        .padding(4)
                        .background(calBlurBackground(isBlur: self.isBlur))
                        .cornerRadius(10)
                        .offset(y: 6)
                        //
                    }
                    //
                    //
                    if isWord && storedData.customWord1 != "" && isKitty && storedData.display == .customize{
                        Text(storedData.customWord1)
                            .font(.custom(font.rawValue, size: storedData.customFont1))
                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.storedData.fontColor).light)
                            .padding(4)
                            .background(calBlurBackground(isBlur: self.isBlur))
                            .cornerRadius(10)
                            .offset(y: 6)
                        
                    }
                    //
                    if isWord && storedData.display == .event{
                        HStack(alignment: .center){
                            let date0 = MyData.date2zero(date: self.date)
                            let deltaDay = date0.deltaDay(to: storedData.eventDay)
                            if deltaDay >= 0{
                                Text("离")
                                    .font(.custom(font.rawValue, size: storedData.eventFont))
                                    +
                                    Text(storedData.eventName)
                                    .font(.custom(font.rawValue, size: storedData.eventFont + Coefficients.eventFontDelta))
                                    +
                                    Text("还有")
                                    .font(.custom(font.rawValue, size: storedData.eventFont))
                            } else {
                                
                                Text(storedData.eventName)
                                    .font(.custom(font.rawValue, size: storedData.eventFont + Coefficients.eventFontDelta))
                                    +
                                    Text("已经")
                                    .font(.custom(font.rawValue, size: storedData.eventFont))
                            }
                            
                        }
                        .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.storedData.fontColor).light)
                        .padding(4)
                        .background(calBlurBackground(isBlur: self.isBlur))
                        .cornerRadius(10)
                        .offset(y: 6)
                    }
                    
                }
                .padding(3)
                //
                if isKitty{
                    Spacer()
                }
                //
                HStack{
                    if isWord && storedData.display == .date{
                        Spacer()
                        Text(dateSetting(.week, is24Hour: self.is24Hour, date: date))
                            .font(.custom(font.rawValue, size: 19))
                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.storedData.fontColor).main)
                            .padding(3)
                            .background(calBlurBackground(isBlur: self.isBlur))
                            .cornerRadius(10)
                            .padding(3)
                        Spacer()
                    }
                    if isWord && storedData.customWord2 != "" && isKitty && storedData.display == .customize{
                        Spacer()
                        Text(storedData.customWord2)
                            .font(.custom(font.rawValue, size: storedData.customFont2))
                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.storedData.fontColor).light)
                            .padding(3)
                            .background(calBlurBackground(isBlur: self.isBlur))
                            .cornerRadius(10)
                            .offset(y: 5)
                        Spacer()
                    }
                    
                    if isWord && storedData.display == .event{
                        Spacer()
                        HStack(alignment: .center){
                            let date0 = MyData.date2zero(date: self.date)
                            let deltaDay = date0.deltaDay(to: storedData.eventDay)
                            Text(String(abs(deltaDay)))
                                .font(.custom(font.rawValue, size: storedData.eventFont + Coefficients.eventFontDelta))
                                +
                                Text("天")
                                .font(.custom(font.rawValue, size: storedData.eventFont))
                        }
                        .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.storedData.fontColor).light)
                        .padding(4)
                        .background(calBlurBackground(isBlur: self.isBlur))
                        .cornerRadius(10)
                        Spacer()
                    }
                    //
                    if isKitty{
                        Spacer()
                        ZStack{
                            Image(uiImage: UIImage(data: self.storedData.kitty)!)
                                .resizable()
                                .scaledToFit()
                                .clipped()
                        }
                    }
                    //
                }
            }
            
            if isWord && (storedData.customWord2 != "" || storedData.customWord1 != "") && !isKitty && storedData.display == .customize{
                HStack{
                    VStack(alignment: .leading){
                        Spacer()
                        if storedData.customWord1 != ""{
                            Text(storedData.customWord1)
                                .font(.custom(font.rawValue, size: storedData.customFont1))
                                .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.storedData.fontColor).light)
                                .padding(3)
                                .background(calBlurBackground(isBlur: self.isBlur))
                                .cornerRadius(10)
                        }
                        
                        if storedData.customWord2 != ""{
                            Text(storedData.customWord2)
                                .font(.custom(font.rawValue, size: storedData.customFont2))
                                .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.storedData.fontColor).light)
                                .padding(3)
                                .background(calBlurBackground(isBlur: self.isBlur))
                                .cornerRadius(10)
                            //.offset(y: 5)
                        }
                    }
                    Spacer()
                }
                .padding(10)
            }
        }
        .animation(.easeInOut)
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
    
    func returnMonth() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_Hans_CN")
        dateFormatter.dateStyle = .short
        let str = dateFormatter.string(from: Date())
        return str
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
                    Image(uiImage: UIImage(data: self.storedData.blurBackground)!).resizable().scaledToFill().frame(width: geometry.size.width, height: geometry.size.height).clipped()
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
                    Image(uiImage: UIImage(data: self.storedData.blurBackground)!).resizable().scaledToFill().frame(width: geometry.size.width, height: geometry.size.height).clipped()
                    Color(self.colorScheme == .light ? .white : .black).opacity(0.2)
                }
            } else {
                Image(uiImage: UIImage(data:self.storedData.background)!).resizable().scaledToFill().frame(width: geometry.size.width, height: geometry.size.height).clipped()
            }
        }
    }
}


