import SwiftUI
import WidgetKit

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
            calBackground(isAllBlur: self.isAllBlur, basicData: self.basicData)
            HStack{
                if !basicData.isCalendar && isWord{
                    Spacer()
                    VStack{
                        VStack(alignment: .leading){
                            HStack{
                                if is24Hour{
                                    Text(dateSetting(.time, is24Hour: self.is24Hour, date: date))
                                        .font(.custom(font.rawValue, size: 37))
                                        .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)

                                } else {
                                    Text(dateSetting(.time, is24Hour: self.is24Hour, date: date).split(separator: " ").first!)
                                        .font(.custom(font.rawValue, size: 35))
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
                                .offset(x: 8)
                        }
                        .background(calBlurBackground(isBlur: self.isBlur, basicData: self.basicData))
                        .cornerRadius(10)
                        .offset(y: 6)

                        Text(dateSetting(.week, is24Hour: self.is24Hour, date: date))
                            .font(.custom(font.rawValue, size: 21))
                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).main)
                            .padding(3)
                            .background(calBlurBackground(isBlur: self.isBlur, basicData: self.basicData))
                            .cornerRadius(10)
                            .padding(8)
                    }
                }

                if !basicData.isCalendar && basicData.isCustomWord && (basicData.customWord1 != "" ||  basicData.customWord2 != ""  ){
                    VStack(alignment: .leading){
                        Spacer()
                        if  basicData.customWord1 != "" {
                            Text(basicData.customWord1)
                                .font(.custom(font.rawValue, size: basicData.midCustomFont1))
                                .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                .padding(4)
                                .background(calBlurBackground(isBlur: self.isBlur, basicData: self.basicData))
                                .cornerRadius(10)
                        }

                        if basicData.customWord2 != "" {
                            Text(basicData.customWord2)
                                .font(.custom(font.rawValue, size: basicData.midCustomFont2))
                                .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                .padding(4)
                                .background(calBlurBackground(isBlur: self.isBlur, basicData: self.basicData))
                                .cornerRadius(10)
                                .offset(y: 5)
                        }
                    }
                    .padding(12)
                }
                
                if basicData.isCalendar{
                    Spacer()
                    VStack(alignment: .leading){
                        Text(returnMonth().split(separator: "/")[0] + "年" + returnMonth().split(separator: "/")[1] + "月")
                            .font(.system(size: 15))
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
                    .frame(maxWidth: 200)
                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).main)
                    .background(calBlurBackground(isBlur: self.isBlur, basicData: self.basicData))
                    .cornerRadius(10)
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
                
            }
        }
        .environment(\.sizeCategory, .extraExtraExtraLarge)
    }
    
    func returnDay() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_Hans_CN")
        dateFormatter.dateStyle = .short
        let str = dateFormatter.string(from: self.date)
        return String(str.split(separator: "/").last!)
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
                if Int(dateString.first!)! == 12{
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

struct MiddleWidgetView2_Previews: PreviewProvider {
    static var previews: some View {
        MiddleWidgetView2(basicData: BasicData(id: UUID().uuidString, background: UIImage(named: "img8")!, display: .date, kitty: UIImage(named: "kitty1")!, isCustomWord: false, customWord1: "1222lvow", customWord2: "MEMEEMDA", name: "widget 1"), isKitty: true, isWord: true, isBlur: true, isAllBlur: false, is24Hour: false, font: .font4)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
