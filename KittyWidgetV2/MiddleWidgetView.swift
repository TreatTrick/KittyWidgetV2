//
//  MiddleWidgetView.swift
//  KittyWidgetV2
//
//  Created by SORA on 2020/10/26.
//

import SwiftUI
import WidgetKit

struct MiddleWidgetView: View {
    @Environment(\.colorScheme) var colorScheme
    var basicData: BasicData
    var isKitty: Bool
    var isWord: Bool
    var isBlur: Bool
    var isAllBlur: Bool
    var is24Hour: Bool
    var font: FontNames
    
    var body: some View {
        HStack{
            if isWord{
                VStack{
                    VStack(alignment: .leading){
                        HStack{
                            if is24Hour{
                                Text(dateSetting(.time, is24Hour: self.is24Hour, date: Date()))
                               // Text("55:55")
                                    .font(.custom(font.rawValue, size: 45))
                                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                // .opacity(0.6)
                                
                            } else {
                                Text(dateSetting(.time, is24Hour: self.is24Hour, date: Date()).split(separator: ":")[0] + ":" + dateSetting(.time, is24Hour: self.is24Hour, date: Date()).split(separator: ":")[1])
                                //Text("55:55")
                                    .font(.custom(font.rawValue, size: 44))
                                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                //.opacity(0.6)
                                
                                
                                
                                Text(dateSetting(.time, is24Hour: self.is24Hour, date: Date()).split(separator: ":")[2])
                                    .font(.custom(font.rawValue, size: 12))
                                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                    .offset(x: -4, y: 14)
                                // .opacity(0.6)
                                
                            }
                        }
                        
                        Text(dateSetting(.date, is24Hour: self.is24Hour, date: Date()))
                            .font(.custom(font.rawValue, size: 13))
                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).main)
                            .offset(x: 8)
                    }
                    .padding(4)
                    .background(calBlurBackground(isBlur: self.isBlur, basicData: self.basicData))
                    //.cornerRadius(10)
                    .offset(y: 6)
                    
                    Text(dateSetting(.week, is24Hour: self.is24Hour, date: Date()))                        .font(.custom(font.rawValue, size: 25))
                        .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).main)
                        .padding(3)
                        .background(calBlurBackground(isBlur: self.isBlur, basicData: self.basicData))
                        //.cornerRadius(10)
                        .padding()
                }
                .padding(5)
            }
            
                VStack{
                    
                    if basicData.isCustomWord && basicData.customWord1 != "" {
                        Text(basicData.customWord1)
                            .font(.custom(font.rawValue, size: basicData.customFont1))
                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                            .padding(4)
                            .background(calBlurBackground(isBlur: self.isBlur, basicData: self.basicData))
                            //.cornerRadius(10)
                    }
                    
                    if basicData.isCustomWord && basicData.customWord2 != "" {
                        Text(basicData.customWord2)
                            .font(.custom(font.rawValue, size: basicData.customFont2))
                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                            .padding(4)
                            .background(calBlurBackground(isBlur: self.isBlur, basicData: self.basicData))
                            //.cornerRadius(10)
                            .offset(y: 5)
                    }
                }
                .padding(5)
                

            if isKitty && (isWord || (basicData.isCustomWord && basicData.customWord1 != "" && basicData.customWord2 != "")){
                Spacer()
            }
            
            if isKitty{
                VStack{
                Image(uiImage: basicData.kitty)
                    .resizable()
                    .scaledToFit()
                }
                
            }
            
        }
        .frame(width: 350, height: 170, alignment: .center)
        .background(calBackground(isAllBlur: self.isAllBlur, basicData: self.basicData))
        //.cornerRadius(CGFloat(Coefficients//.cornerRadius))
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
                dateFormatter.dateFormat = "h:mm:a"
                let dateString = dateFormatter.string(from: date)
                let ymd = dateString.split(separator:":")
                displayString = ymd[0] + ":" + ymd[1] + ":" + ymd[2]
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
                    Color(self.colorScheme == .light ? .white : .black).opacity(self.colorScheme == .light ? 0.4 : 0.3)
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

struct MiddleWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        MiddleWidgetView(basicData: BasicData(id: UUID().uuidString, background: UIImage(named: "img1")!, display: .date, kitty: UIImage(named: "kitty1")!, isCustomWord: false, customWord1: "1222lvow", customWord2: "MEMEEMDA", name: "widget 1"), isKitty: true, isWord: true, isBlur: true, isAllBlur: false, is24Hour: true, font: .font4)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}


