//
//  SmallWidgetView.swift
//  KittyWidget
//
//  Created by SORA on 2020/9/25.
//

import SwiftUI
import WidgetKit

struct SmallWidgetView: View {
    @EnvironmentObject var myData: MyData
    @Environment(\.editMode) var editMode
    @Environment(\.colorScheme) var colorScheme
    var basicData: BasicData
    var isKitty: Bool
    var isWord: Bool
    var isBlur: Bool
    var isAllBlur: Bool
    var is24Hour: Bool
    var font: FontNames
    
    var body: some View {
        
        ZStack{
            VStack(alignment:.center){
                Group{
                    if isWord && basicData.display == .date{
                    VStack(alignment: .leading){
                        HStack{
                            if !basicData.isCalendar{
                                if is24Hour{
                                    Time(dateSetting: .time,a: false, is24Hour: is24Hour)
                                        .font(.custom(font.rawValue, size: 20))
                                        .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                } else {
                                    Time(dateSetting: .time,a: false, is24Hour: is24Hour)
                                        .font(.custom(font.rawValue, size: 20))
                                        .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                    Time(dateSetting: .time, a: true, is24Hour: is24Hour)
                                        .font(.custom(font.rawValue, size: Coefficients.apSize))
                                        .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                        .offset(x: -4, y: 5)
                                }
                            } else {
                                Text(returnMonth().split(separator: "/")[1] + "月" + returnMonth().split(separator: "/")[2] + "日")
                                    .font(.custom(font.rawValue, size: 20))
                                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                            }
                            
                            if editMode?.wrappedValue != .inactive {
                                Image(systemName: withAnimation(.easeInOut){self.basicData.isChecked ? "checkmark.circle.fill" :  "circle"})
                                    .foregroundColor(.red)
                            }
                        }
                    
                        if !basicData.isCalendar{
                            Time(dateSetting: .date, a: false, is24Hour: is24Hour)
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
                            let deltaDay = Date().deltaDay(to: basicData.eventDay)
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
                            let deltaDay = Date().deltaDay(to: basicData.eventDay)
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
                                //.frame(width: 70, height: 99)
                                .clipped()
                        }
                        //.frame(maxWidth: 70, maxHeight: 98, alignment: .center)
                        //.frame(width: 70, height: 99)
                    }
                    
                }
            }
            .frame(width: 150, height: 150)
            .background( calBackground(isAllBlur: self.isAllBlur, basicData: self.basicData) )
            .environment(\.sizeCategory, .extraExtraExtraLarge)
            .cornerRadius(CGFloat(Coefficients.cornerRadius))
            
            
            if isWord && (basicData.customWord2 != "" || basicData.customWord1 != "") && !isKitty && basicData.display == .customize{
                HStack{
                    VStack(alignment: .leading){
                        Spacer()
                        Text(basicData.customWord1)
                            .font(.custom(font.rawValue, size: basicData.customFont1))
                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                            .padding(3)
                            .background(calBlurBackground(isBlur: self.isBlur, basicData: self.basicData))
                            .cornerRadius(10)
                        
                        Text(basicData.customWord2)
                            .font(.custom(font.rawValue, size: basicData.customFont2))
                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                            .padding(3)
                            .background(calBlurBackground(isBlur: self.isBlur, basicData: self.basicData))
                            .cornerRadius(10)
                            //.offset(y: 5)
                    }
                    Spacer()
                }
                .padding(10)
                .frame(width: 150, height: 150)
                .background(calBackground(isAllBlur: self.isAllBlur, basicData: self.basicData) )
                .environment(\.sizeCategory, .extraExtraExtraLarge)
                .cornerRadius(CGFloat(Coefficients.cornerRadius))
                .animation(.easeInOut)
            }
            
            if editMode?.wrappedValue != .inactive && !isWord{
                Image(systemName: withAnimation(.easeInOut){self.basicData.isChecked ? "checkmark.circle.fill" :  "circle"})
                    .foregroundColor(.red)
                    .padding(4)
                    .background(calBlurBackground(isBlur: true, basicData: self.basicData))
                    .cornerRadius(10)
                    .offset(x:60, y: -60)
            }
            
            if editMode?.wrappedValue == .active{
                Button(action: { self.selectItem() } ){
                    Color(.clear)
                }
            }
            
            
            
        }
        .animation(.easeInOut)
    }
    
    func returnMonth() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_Hans_CN")
        dateFormatter.dateStyle = .short
        let str = dateFormatter.string(from: Date())
        return str
    }
    
    func selectItem(){
        let ind = self.myData.dataStream.firstIndex(where: {$0.id == basicData.id})!
        self.myData.dataStream[ind].isChecked.toggle()
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
                    Color(self.colorScheme == .light ? .white : .black)
                        .opacity(0.2)
                }
            } else {
                Image(uiImage: basicData.background).resizable().scaledToFill().frame(width: geometry.size.width, height: geometry.size.height).clipped()
            }
        }
        
    }
}

//MARK: - time view
struct Time: View{
    @EnvironmentObject var myData: MyData
    var dateSetting: tdSelection
    var a: Bool
    var is24Hour: Bool
    
    var body: some View{
        if dateSetting != .time{
            Text(dateSetting(dateSetting))
        } else {
            if is24Hour{
                Text(dateSetting(dateSetting))
            } else {
                let strSetting = dateSetting(.time).split(separator: ":")
                if a {
                    Text(Int(strSetting.first!)! >= 12 ? "PM" : "AM")
                } else if (Int(strSetting.first!)! == 12) || (Int(strSetting.first!)! == 0){
                    let hour = 12
                    Text(String(hour) + ":" + strSetting.last!)
                } else {
                    let str = strSetting.first!
                    let hour = Int(str)! % 12
                    Text(String(hour) + ":" + strSetting.last!)
                }
            }
        }
    }
    
    func dateSetting(_ timeOrDate: tdSelection) -> String{
        var displayString: String
        let dateFormatter = DateFormatter()
        let date = Date()
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
//                dateFormatter.timeStyle = .short
//                dateFormatter.dateStyle = .none
                dateFormatter.dateFormat = "HH:mm"
                let dateString = dateFormatter.string(from: date)
//                let ymd = dateString.split(separator:":")
//                displayString = ymd[0] + ":" + ymd[1] + ":" + ymd[2]
                displayString = dateString
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
}


//MARK: - Preview

struct SmallWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        SmallWidgetView(basicData: BasicData(id: UUID().uuidString, background: UIImage(named: "img1")!, display: .date, kitty: UIImage(named: "kitty1")!, name: "widget 1"), isKitty: true, isWord: true, isBlur: true, isAllBlur: true, is24Hour: true, font: .font4)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
