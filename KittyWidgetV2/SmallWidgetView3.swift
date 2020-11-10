import SwiftUI
import WidgetKit

struct SmallWidgetView3: View {
    @Environment(\.colorScheme) var colorScheme
    var basicData: BasicData
    var isKitty: Bool
    var isWord: Bool
    var isBlur: Bool
    var isAllBlur: Bool
    var is24Hour: Bool
    var font: FontNames
    var date = Date()
    
    var body: some View {
        ZStack {
            calBackground(isAllBlur: self.isAllBlur, basicData: self.basicData)
            VStack(alignment:.center){
                Group{
                    if isWord && basicData.display == .date{
                        VStack(alignment: .leading){
                            HStack{
                                if !basicData.isCalendar{
                                    if is24Hour{
                                        Text(dateSetting(.time, is24Hour: self.is24Hour, date: date))
                                            .font(.custom(font.rawValue, size: 25))
                                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)

                                    } else {
                                        Text(dateSetting(.time, is24Hour: self.is24Hour, date: date).split(separator: " ").first!)
                                            .font(.custom(font.rawValue, size: 25))
                                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)

                                        Text(dateSetting(.time, is24Hour: self.is24Hour, date: date).split(separator: " ").last!)
                                            .font(.custom(font.rawValue, size: Coefficients.apSize))
                                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                            .offset(x: -4, y: 5)
                                    }
                     
                                } else {
                                    Text(returnMonth().split(separator: "/")[1] + "月" + returnMonth().split(separator: "/")[2] + "日")
                                        .font(.custom(font.rawValue, size: 20))
                                        .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                }
                            }

                            if !basicData.isCalendar{
                                Text(dateSetting(.date, is24Hour: self.is24Hour, date: date))
                                    .font(.custom(font.rawValue, size: 10))
                                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).main)
                                    .offset(x: 8)
                            } else {
                                Text(returnMonth().split(separator: "/")[0] + "年")
                                    .font(.custom(font.rawValue, size: 10))
                                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).main)
                                    .offset(x: 8)
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
                        Text(dateSetting(.week, is24Hour: self.is24Hour, date: date))
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
    
    func calBlurBackground(isBlur: Bool, basicData: BasicData) -> some View{
        GeometryReader{ geometry in
            if isBlur{
                ZStack{
                    Image(uiImage: self.basicData.blurBackground).resizable().scaledToFill().frame(width: geometry.size.width, height: geometry.size.height).clipped()
                    Color(self.colorScheme == .light ? .white : .black).opacity(self.colorScheme == .light ? 0.3 : 0.25)
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

struct SmallWidgetView3_Previews: PreviewProvider {
    static var previews: some View {
        SmallWidgetView3(basicData: BasicData(id: UUID().uuidString, background: UIImage(named: "img8")!, display: .date, kitty: UIImage(named: "kitty1")!, name: "widget 1"), isKitty: true, isWord: true, isBlur: true, isAllBlur: false, is24Hour: true, font: .font4)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
