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
                    if isWord{
                        VStack(alignment: .leading){
                            HStack{
                                if is24Hour{
                                    Text(dateSetting(.time, is24Hour: self.is24Hour, date: date))
                                        .font(.custom(font.rawValue, size: 32))
                                        .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)

                                } else {
                                    Text(dateSetting(.time, is24Hour: self.is24Hour, date: date).split(separator: " ").first!)
                                        .font(.custom(font.rawValue, size: 27))
                                        .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)

                                    Text(dateSetting(.time, is24Hour: self.is24Hour, date: date).split(separator: " ").last!)
                                        .font(.custom(font.rawValue, size: Coefficients.apSize))
                                        .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                        .offset(x: -4, y: 10)
                                }
                            }

                            Text(dateSetting(.date, is24Hour: self.is24Hour, date: date))
                                .font(.custom(font.rawValue, size: 10))
                                .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).main)
                                .offset(x: 8)
                        }
                        .padding(4)
                        .background(calBlurBackground(isBlur: self.isBlur, basicData: self.basicData))
                        .cornerRadius(10)
                        .offset(y: 6)

                    }


                    if basicData.isCustomWord && basicData.customWord1 != ""{
                        Text(basicData.customWord1)
                            .font(.custom(font.rawValue, size: basicData.customFont1))
                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                            .padding(4)
                            .background(calBlurBackground(isBlur: self.isBlur, basicData: self.basicData))
                        .cornerRadius(10)
                    }
                }
                .padding(3)
                

                HStack{
                    if isWord{
                        Spacer()
                        Text(dateSetting(.week, is24Hour: self.is24Hour, date: date))
                            .font(.custom(font.rawValue, size: 23))
                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).main)
                            .padding(3)
                            .background(calBlurBackground(isBlur: self.isBlur, basicData: self.basicData))
                            .cornerRadius(10)
                            .padding(3)
                        Spacer()
                    }
                    if basicData.isCustomWord && basicData.customWord2 != ""{
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
                    if isKitty{
                        ZStack{
                            Image(uiImage: basicData.kitty)
                                .resizable()
                                .scaledToFit()
                                .clipped()
                        }
                        //.frame(maxWidth: 70, maxHeight: 98, alignment: .center)
                    }
                    
                }
            }
        }
        .animation(.easeInOut)
        .environment(\.sizeCategory, .extraExtraExtraLarge)
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
                if Int(dateString.first!)! > 12 {
                    ap = "PM"
                } else {
                    ap = "AM"
                }
                let hour = Int(dateString.first!)! % 12
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

struct SmallWidgetView3_Previews: PreviewProvider {
    static var previews: some View {
        SmallWidgetView3(basicData: BasicData(id: UUID().uuidString, background: UIImage(named: "img8")!, display: .date, kitty: UIImage(named: "kitty1")!, name: "widget 1"), isKitty: true, isWord: true, isBlur: true, isAllBlur: false, is24Hour: true, font: .font4)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
