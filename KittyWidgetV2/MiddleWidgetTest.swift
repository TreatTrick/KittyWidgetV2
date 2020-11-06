//
//  MiddleWidgetTest.swift
//  KittyWidgetV2
//
//  Created by SORA on 2020/11/6.
//

import SwiftUI
import WidgetKit

struct MiddleWidgetTest: View {
    @Environment(\.colorScheme) var colorScheme
    var basicData: BasicData
    var isKitty: Bool
    var isWord: Bool
    var isBlur: Bool
    var isAllBlur: Bool
    var is24Hour: Bool
    var font: FontNames
    var date = Date()
    @State var str = "nihao"
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7)
    var weekdays: [String] = ["日","一","二","三","四","五","六"]
    
    var body: some View {
        HStack{
           
//            Text(str)
//
//            Button("tapme"){
//                let range = Calendar.current.range(of: .day, in: .month, for: Date())!
//                let dateFormatter = DateFormatter()
//                dateFormatter.locale = Locale(identifier: "zh_Hans_CN")
//                dateFormatter.dateStyle = .short
////                self.str = String(Calendar.current.firstWeekday)
//                self.str = dateFormatter.string(from: Date())
//            }
            Spacer()
            VStack(alignment: .leading){
                Text(returnMonth() + "月")
                    .font(.system(size: 15))
                LazyVGrid(columns: columns){
                    ForEach(weekdays, id: \.self){ value in
                        Text(value)
                            .font(.system(size: 10))
                    }
                    ForEach(dateList(), id:\.self){ value in
                        Text(value)
                            .font(.system(size: 10))
                            .background(
                                Group{
                                    if value == String(26){
                                        Circle().foregroundColor(Color(hex: 0xFFFFFF - 0x0080FF)).frame(width: 15, height: 15, alignment: .center)
                                    } else {
                                        EmptyView()
                                    }
                                }
                            )
                    }
                }

            }
            .foregroundColor(Color(hex: 0x0080FF))
                
            Spacer()
            
            if isKitty{
                ZStack{
                    Image(uiImage: basicData.kitty)
                        .resizable()
                        .scaledToFit()
                        .clipped()
                }
                //.frame(width: 105, height: 150)
            }
            
        }
        .frame(width: 317, height: 150, alignment: .center)
        .background(calBackground(isAllBlur: self.isAllBlur, basicData: self.basicData))
        .cornerRadius(CGFloat(Coefficients.cornerRadius))
        .environment(\.sizeCategory, .extraExtraExtraLarge)
    }
    
    func returnMonth() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_Hans_CN")
        dateFormatter.dateStyle = .short
        let str = dateFormatter.string(from: Date())
        return String(str.split(separator: "/")[1])
    }
    
    func returnDay() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_Hans_CN")
        dateFormatter.dateStyle = .short
        let str = dateFormatter.string(from: Date())
        return String(str.split(separator: "/").last!)
    }
    
    func dateList() -> [String]{
        let range = Calendar.current.range(of: .day, in: .month, for: Date())!
        let firstDay = Calendar.current.firstWeekday
        var dateList: [String] = []
        for _ in 0..<firstDay-1{
            dateList.append(" ")
        }
        for i in 1...range.count{
            dateList.append(String(i + 20))
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

struct MiddleWidgetTest_Previews: PreviewProvider {
    static var previews: some View {
        MiddleWidgetTest(basicData: BasicData(id: UUID().uuidString, background: UIImage(named: "img8")!, display: .date, kitty: UIImage(named: "kitty1")!, isCustomWord: false, customWord1: "1222lvow", customWord2: "MEMEEMDA", name: "widget 1"), isKitty: true, isWord: true, isBlur: true, isAllBlur: false, is24Hour: false, font: .font4)
           // .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
